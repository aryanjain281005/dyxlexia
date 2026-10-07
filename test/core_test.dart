import 'package:akshara_path/core/games.dart';
import 'package:akshara_path/core/scoring.dart';
import 'package:akshara_path/core/skills.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('there are six skills with unique ids', () {
    expect(Skill.values, hasLength(6));
    expect(Skill.values.map((s) => s.id).toSet(), hasLength(6));
  });

  test('11 games, each owned by one skill, every skill has a game', () {
    expect(kGames, hasLength(11));
    expect(kGames.map((g) => g.id).toSet(), hasLength(11));
    for (final skill in Skill.values) {
      expect(gamesForSkill(skill), isNotEmpty, reason: skill.label);
    }
  });

  test('MVP demo set has one game per skill', () {
    final demo = kGames.where((g) => g.inMvpDemo).toList();
    expect(demo.map((g) => g.skill).toSet(), Skill.values.toSet());
    expect(demo, hasLength(6));
  });

  test('error tags are not shared across skills', () {
    final all = Skill.values.expand((s) => s.errorTags).toList();
    expect(all.toSet(), hasLength(all.length));
    expect(all.toSet(), ErrorTag.values.toSet());
  });

  group('classifySkill', () {
    test('needs enough items before assigning a band', () {
      expect(classifySkill(correct: 2, total: 2), isNull);
    });

    test('maps accuracy to bands', () {
      expect(classifySkill(correct: 4, total: 5), SkillBand.strong);
      expect(classifySkill(correct: 3, total: 5), SkillBand.developing);
      expect(classifySkill(correct: 1, total: 5), SkillBand.needsSupport);
    });
  });

  test('starting level differs by band', () {
    expect(
      startingLevelFor(SkillBand.needsSupport),
      lessThan(startingLevelFor(SkillBand.developing)),
    );
    expect(
      startingLevelFor(SkillBand.developing),
      lessThan(startingLevelFor(SkillBand.strong)),
    );
  });
}
