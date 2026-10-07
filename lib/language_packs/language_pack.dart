import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/skills.dart';

/// Which pool an item belongs to. Reassessment items are never used in
/// practice, so weekly progress reflects transfer, not memorisation
/// (spec section 8, "Fresh-item rule").
enum ItemPool {
  baseline('baseline'),
  practice('practice'),
  reassessment('reassessment');

  const ItemPool(this.id);
  final String id;

  static ItemPool fromId(String id) => values.firstWhere((p) => p.id == id);
}

/// One assessment or practice item with the content metadata the common
/// engine needs (spec section 10): skill, difficulty, error tags, item type.
class ContentItem {
  const ContentItem({
    required this.id,
    required this.skill,
    required this.type,
    required this.difficulty,
    required this.pool,
    required this.prompt,
    required this.answer,
    this.options = const [],
    this.audio,
    this.storyId,
    this.errorTags = const [],
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
    id: json['id'] as String,
    skill: Skill.fromId(json['skill'] as String),
    type: json['type'] as String,
    difficulty: json['difficulty'] as int,
    pool: ItemPool.fromId(json['pool'] as String),
    prompt: json['prompt'] as String,
    answer: json['answer'] as String,
    options: (json['options'] as List? ?? const []).cast<String>(),
    audio: json['audio'] as String?,
    storyId: json['storyId'] as String?,
    errorTags: (json['errorTags'] as List? ?? const [])
        .map((t) => ErrorTag.fromId(t as String))
        .toList(),
  );

  final String id;
  final Skill skill;
  final String type;
  final int difficulty;
  final ItemPool pool;
  final String prompt;
  final String answer;
  final List<String> options;

  /// Path of a prepackaged audio clip inside the pack, if any.
  final String? audio;

  /// Story this question belongs to (comprehension items only).
  final String? storyId;

  /// Error tags a wrong answer to this item can reveal.
  final List<ErrorTag> errorTags;
}

/// Script inventory for akshara-aware content: vowels, consonants, matras
/// and conjuncts are listed explicitly rather than derived from English.
class ScriptInventory {
  const ScriptInventory({
    required this.vowels,
    required this.consonants,
    required this.matras,
    required this.conjuncts,
  });

  factory ScriptInventory.fromJson(Map<String, dynamic> json) =>
      ScriptInventory(
        vowels: (json['vowels'] as List).cast<String>(),
        consonants: (json['consonants'] as List).cast<String>(),
        matras: (json['matras'] as List).cast<String>(),
        conjuncts: (json['conjuncts'] as List).cast<String>(),
      );

  final List<String> vowels;
  final List<String> consonants;
  final List<String> matras;
  final List<String> conjuncts;
}

class Story {
  const Story({required this.id, required this.title, required this.text});

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json['id'] as String,
    title: json['title'] as String,
    text: json['text'] as String,
  );

  final String id;
  final String title;
  final String text;
}

/// A language pack sits on top of the common engine and supplies everything
/// language-specific: script, words, stories, audio and child-facing names.
class LanguagePack {
  const LanguagePack({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.script,
    required this.inventory,
    required this.skillNames,
    required this.items,
    required this.stories,
  });

  factory LanguagePack.fromJson(Map<String, dynamic> json) => LanguagePack(
    code: json['code'] as String,
    name: json['name'] as String,
    nativeName: json['nativeName'] as String,
    script: json['script'] as String,
    inventory: ScriptInventory.fromJson(
      json['inventory'] as Map<String, dynamic>,
    ),
    skillNames: {
      for (final e in (json['skillNames'] as Map<String, dynamic>).entries)
        Skill.fromId(e.key): e.value as String,
    },
    items: (json['items'] as List)
        .map((i) => ContentItem.fromJson(i as Map<String, dynamic>))
        .toList(),
    stories: (json['stories'] as List)
        .map((s) => Story.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  final String code;
  final String name;
  final String nativeName;
  final String script;
  final ScriptInventory inventory;

  /// Child-facing name of each skill in this language.
  final Map<Skill, String> skillNames;
  final List<ContentItem> items;
  final List<Story> stories;

  List<ContentItem> itemsFor(Skill skill, ItemPool pool) =>
      items.where((i) => i.skill == skill && i.pool == pool).toList();
}

/// Languages bundled with the app. Adding a language means adding a folder
/// under `assets/language_packs/` and a line here; the engine is unchanged.
const List<String> kBundledLanguages = ['hi'];

String packAssetPath(String code) => 'assets/language_packs/$code/pack.json';

Future<LanguagePack> loadLanguagePack(
  String code, {
  AssetBundle? bundle,
}) async {
  final raw = await (bundle ?? rootBundle).loadString(packAssetPath(code));
  return LanguagePack.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
