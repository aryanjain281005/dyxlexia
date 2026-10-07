import 'dart:convert';
import 'dart:io';

import 'package:akshara_path/core/safety_language.dart';
import 'package:akshara_path/core/scoring.dart';
import 'package:akshara_path/core/skills.dart';
import 'package:akshara_path/language_packs/language_pack.dart';
import 'package:flutter_test/flutter_test.dart';

LanguagePack readPack(String code) => LanguagePack.fromJson(
  jsonDecode(File(packAssetPath(code)).readAsStringSync())
      as Map<String, dynamic>,
);

void main() {
  for (final code in kBundledLanguages) {
    group('language pack "$code"', () {
      final pack = readPack(code);

      test('names every skill', () {
        expect(pack.skillNames.keys.toSet(), Skill.values.toSet());
      });

      test('has enough baseline and reassessment items per skill', () {
        for (final skill in Skill.values) {
          expect(
            pack.itemsFor(skill, ItemPool.baseline).length,
            greaterThanOrEqualTo(kMinItemsForBand),
            reason: skill.label,
          );
          expect(
            pack.itemsFor(skill, ItemPool.reassessment).length,
            greaterThanOrEqualTo(kMinItemsForBand),
            reason: skill.label,
          );
        }
      });

      test('item ids are unique and reassessment prompts are fresh', () {
        expect(
          pack.items.map((i) => i.id).toSet(),
          hasLength(pack.items.length),
        );
        final seen = pack.items
            .where((i) => i.pool != ItemPool.reassessment)
            .map((i) => '${i.prompt}|${i.answer}')
            .toSet();
        for (final item in pack.items.where(
          (i) => i.pool == ItemPool.reassessment,
        )) {
          expect(
            seen,
            isNot(contains('${item.prompt}|${item.answer}')),
            reason: item.id,
          );
        }
      });

      test('answers are among the options for choice items', () {
        for (final item in pack.items.where((i) => i.type != 'build_word')) {
          expect(item.options, contains(item.answer), reason: item.id);
        }
      });

      test('error tags belong to the item skill', () {
        for (final item in pack.items) {
          for (final tag in item.errorTags) {
            expect(item.skill.errorTags, contains(tag), reason: item.id);
          }
        }
      });

      test('comprehension items point at a story in the pack', () {
        final storyIds = pack.stories.map((s) => s.id).toSet();
        for (final item in pack.items.where(
          (i) => i.skill == Skill.readingComprehension,
        )) {
          expect(storyIds, contains(item.storyId), reason: item.id);
        }
      });
    });
  }

  test('no diagnostic wording in app source or packs', () {
    final files =
        [
          ...Directory('lib').listSync(recursive: true),
          ...Directory('assets').listSync(recursive: true),
        ].whereType<File>().where(
          (f) =>
              !f.path.endsWith('safety_language.dart') &&
              (f.path.endsWith('.dart') || f.path.endsWith('.json')),
        );
    for (final file in files) {
      final text = file.readAsStringSync().toLowerCase();
      for (final phrase in kForbiddenPhrases) {
        expect(
          text,
          isNot(contains(phrase)),
          reason: '${file.path} contains "$phrase"',
        );
      }
    }
  });
}
