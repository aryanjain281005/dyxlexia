import 'dart:convert';
import 'dart:io';

import 'package:akshara_path/app.dart';
import 'package:akshara_path/core/skills.dart';
import 'package:akshara_path/data/app_database.dart';
import 'package:akshara_path/language_packs/language_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  late AppDatabase database;
  late LanguagePack pack;

  setUp(() async {
    database = await AppDatabase.open(
      factory: databaseFactoryFfiNoIsolate,
      path: inMemoryDatabasePath,
    );
    pack = LanguagePack.fromJson(
      jsonDecode(File(packAssetPath('hi')).readAsStringSync())
          as Map<String, dynamic>,
    );
  });

  tearDown(() => database.close());

  test('database creates and reads a child profile and skill bands', () async {
    final childId = await database.createChild(
      nickname: 'Tara',
      languageCode: 'hi',
      ageYears: 7,
    );
    final child = await database.activeChild();
    expect(child?.nickname, 'Tara');

    final sessionId = await database.db.insert('assessment_session', {
      'child_id': childId,
      'kind': 'baseline',
      'language_code': 'hi',
      'started_at': DateTime(2026).toIso8601String(),
    });
    await database.db.insert('skill_result', {
      'session_id': sessionId,
      'child_id': childId,
      'skill': Skill.decoding.id,
      'correct': 1,
      'total': 3,
      'band': SkillBand.needsSupport.id,
      'created_at': DateTime(2026).toIso8601String(),
    });
    expect(await database.latestBands(childId), {
      Skill.decoding: SkillBand.needsSupport,
    });
  });

  testWidgets('app starts on the home screen and opens each section', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        AksharaPathApp(database: database, languagePack: pack),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text('Akshara Path'), findsOneWidget);
    expect(find.text('No child profile yet'), findsOneWidget);

    for (final (card, title) in [
      ('Skill check', 'Skill check'),
      ('Practice', 'Practice'),
      ('Weekly recheck', 'Weekly recheck'),
    ]) {
      await tester.tap(find.text(card));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, title), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    await tester.runAsync(() async {
      await tester.tap(find.text('Progress'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Progress'), findsOneWidget);
    expect(find.text('Not assessed yet'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text(Skill.readingComprehension.label),
      200,
    );
    expect(find.text(Skill.readingComprehension.label), findsOneWidget);
  });
}
