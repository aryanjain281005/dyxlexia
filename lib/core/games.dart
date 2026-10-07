import 'skills.dart';

/// One of the 11 dedicated games (spec section 5). Every game is owned by
/// exactly one skill; no game is the primary game for two skills.
class GameDefinition {
  const GameDefinition({
    required this.id,
    required this.name,
    required this.skill,
    required this.mechanic,
    this.inMvpDemo = false,
  });

  final String id;
  final String name;
  final Skill skill;
  final String mechanic;

  /// Part of the recommended hackathon demo set (spec section 14).
  final bool inMvpDemo;
}

const List<GameDefinition> kGames = [
  GameDefinition(
    id: 'sound_orchestra',
    name: 'Sound Orchestra',
    skill: Skill.phonologicalAwareness,
    mechanic:
        'Arrange and hear sound units: blend, segment, delete, substitute.',
    inMvpDemo: true,
  ),
  GameDefinition(
    id: 'sound_ninja',
    name: 'Sound Ninja',
    skill: Skill.phonologicalAwareness,
    mechanic: 'Identify, remove or replace sounds in spoken words.',
  ),
  GameDefinition(
    id: 'letter_archer',
    name: 'Letter Archer',
    skill: Skill.graphemePhoneme,
    mechanic: 'Hear a sound and hit the matching akshara.',
    inMvpDemo: true,
  ),
  GameDefinition(
    id: 'sound_portal',
    name: 'Sound Portal',
    skill: Skill.graphemePhoneme,
    mechanic: 'Connect written symbols and patterns with their sounds.',
  ),
  GameDefinition(
    id: 'word_rocket',
    name: 'Word Rocket',
    skill: Skill.decoding,
    mechanic: 'Blend written akshara units to launch a rocket.',
    inMvpDemo: true,
  ),
  GameDefinition(
    id: 'word_builder',
    name: 'Word Builder',
    skill: Skill.decoding,
    mechanic: 'Construct an unfamiliar word from akshara components.',
  ),
  GameDefinition(
    id: 'word_detective',
    name: 'Word Detective',
    skill: Skill.wordRecognition,
    mechanic:
        'Find the correctly written familiar word among close distractors.',
    inMvpDemo: true,
  ),
  GameDefinition(
    id: 'word_flash',
    name: 'Word Flash',
    skill: Skill.wordRecognition,
    mechanic: 'See a word briefly, then pick it from alternatives.',
  ),
  GameDefinition(
    id: 'spelling_hive',
    name: 'Spelling Hive',
    skill: Skill.spellingWriting,
    mechanic: 'Hear a word and build it from akshara and matra tiles.',
    inMvpDemo: true,
  ),
  GameDefinition(
    id: 'magic_writer',
    name: 'Magic Writer',
    skill: Skill.spellingWriting,
    mechanic: 'Trace and write aksharas, words and short sentences.',
  ),
  GameDefinition(
    id: 'story_quest',
    name: 'Story Quest',
    skill: Skill.readingComprehension,
    mechanic: 'Interactive stories with sequence, cause/effect and inference questions.',
    inMvpDemo: true,
  ),
];

List<GameDefinition> gamesForSkill(Skill skill) =>
    kGames.where((g) => g.skill == skill).toList();
