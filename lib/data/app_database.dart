import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../core/skills.dart';

/// Local SQLite store. Everything stays on the device (spec section 12):
/// no phone number, location, Aadhaar or photos are ever stored.
class AppDatabase {
  AppDatabase._(this.db);

  final Database db;

  static const fileName = 'akshara_path.db';
  static const schemaVersion = 1;

  /// Opens (or creates) the database. Pass [factory] and [path] in tests to
  /// use an in-memory FFI database.
  static Future<AppDatabase> open({
    DatabaseFactory? factory,
    String? path,
  }) async {
    final f = factory ?? databaseFactory;
    final dbPath = path ?? p.join(await f.getDatabasesPath(), fileName);
    final db = await f.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => _createV1(db),
      ),
    );
    return AppDatabase._(db);
  }

  static Future<void> _createV1(Database db) async {
    final batch = db.batch();
    // Minimal child profile: a nickname, not a real-world identity.
    batch.execute('''
      CREATE TABLE child_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nickname TEXT NOT NULL,
        age_years INTEGER,
        class_level TEXT,
        language_code TEXT NOT NULL,
        consent_given_at TEXT NOT NULL,
        created_at TEXT NOT NULL
      )''');
    batch.execute('''
      CREATE TABLE settings (
        child_id INTEGER NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
        key TEXT NOT NULL,
        value TEXT NOT NULL,
        PRIMARY KEY (child_id, key)
      )''');
    // kind: 'baseline' or 'reassessment'.
    batch.execute('''
      CREATE TABLE assessment_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id INTEGER NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
        kind TEXT NOT NULL CHECK (kind IN ('baseline', 'reassessment')),
        language_code TEXT NOT NULL,
        started_at TEXT NOT NULL,
        completed_at TEXT
      )''');
    batch.execute('''
      CREATE TABLE assessment_response (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL REFERENCES assessment_session(id) ON DELETE CASCADE,
        item_id TEXT NOT NULL,
        skill TEXT NOT NULL,
        correct INTEGER NOT NULL,
        error_tag TEXT,
        response_ms INTEGER,
        answered_at TEXT NOT NULL
      )''');
    // One row per skill per assessment: the six-skill profile.
    batch.execute('''
      CREATE TABLE skill_result (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL REFERENCES assessment_session(id) ON DELETE CASCADE,
        child_id INTEGER NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
        skill TEXT NOT NULL,
        correct INTEGER NOT NULL,
        total INTEGER NOT NULL,
        band TEXT NOT NULL CHECK (band IN ('strong', 'developing', 'needs_support')),
        created_at TEXT NOT NULL,
        UNIQUE (session_id, skill)
      )''');
    // Current practice level, tracked independently for every skill.
    batch.execute('''
      CREATE TABLE skill_level (
        child_id INTEGER NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
        skill TEXT NOT NULL,
        level INTEGER NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (child_id, skill)
      )''');
    batch.execute('''
      CREATE TABLE practice_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id INTEGER NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
        game_id TEXT NOT NULL,
        skill TEXT NOT NULL,
        level INTEGER NOT NULL,
        started_at TEXT NOT NULL,
        duration_seconds INTEGER
      )''');
    batch.execute('''
      CREATE TABLE practice_attempt (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        practice_session_id INTEGER NOT NULL REFERENCES practice_session(id) ON DELETE CASCADE,
        item_id TEXT NOT NULL,
        correct INTEGER NOT NULL,
        error_tag TEXT,
        response_ms INTEGER,
        attempted_at TEXT NOT NULL
      )''');
    batch.execute(
      'CREATE INDEX idx_skill_result_child ON skill_result(child_id, created_at)',
    );
    batch.execute(
      'CREATE INDEX idx_practice_session_child ON practice_session(child_id, started_at)',
    );
    await batch.commit(noResult: true);
  }

  Future<void> close() => db.close();

  // --- Child profile -------------------------------------------------------

  Future<int> createChild({
    required String nickname,
    required String languageCode,
    int? ageYears,
    String? classLevel,
    DateTime? now,
  }) {
    final ts = (now ?? DateTime.now()).toIso8601String();
    return db.insert('child_profile', {
      'nickname': nickname,
      'age_years': ageYears,
      'class_level': classLevel,
      'language_code': languageCode,
      'consent_given_at': ts,
      'created_at': ts,
    });
  }

  /// The most recently created profile, or null before adult setup.
  Future<ChildProfile?> activeChild() async {
    final rows = await db.query('child_profile', orderBy: 'id DESC', limit: 1);
    return rows.isEmpty ? null : ChildProfile.fromRow(rows.first);
  }

  // --- Skill profile -------------------------------------------------------

  /// Latest band for each skill that has been assessed.
  Future<Map<Skill, SkillBand>> latestBands(int childId) async {
    final rows = await db.rawQuery(
      '''
      SELECT r.skill, r.band FROM skill_result r
      JOIN (
        SELECT skill, MAX(id) AS max_id FROM skill_result
        WHERE child_id = ? GROUP BY skill
      ) latest ON latest.max_id = r.id
    ''',
      [childId],
    );
    return {
      for (final r in rows)
        Skill.fromId(r['skill'] as String): SkillBand.fromId(
          r['band'] as String,
        ),
    };
  }

  Future<Map<Skill, int>> skillLevels(int childId) async {
    final rows = await db.query(
      'skill_level',
      where: 'child_id = ?',
      whereArgs: [childId],
    );
    return {
      for (final r in rows)
        Skill.fromId(r['skill'] as String): r['level'] as int,
    };
  }
}

class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.nickname,
    required this.languageCode,
    this.ageYears,
    this.classLevel,
  });

  factory ChildProfile.fromRow(Map<String, Object?> row) => ChildProfile(
    id: row['id'] as int,
    nickname: row['nickname'] as String,
    languageCode: row['language_code'] as String,
    ageYears: row['age_years'] as int?,
    classLevel: row['class_level'] as String?,
  );

  final int id;
  final String nickname;
  final String languageCode;
  final int? ageYears;
  final String? classLevel;
}
