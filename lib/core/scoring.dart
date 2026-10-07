import 'skills.dart';

/// Placeholder thresholds for turning per-skill accuracy into a band.
///
/// The spec says exact thresholds must be tuned during validation, so these
/// are deliberately isolated here and not used anywhere as a "diagnosis".
class BandThresholds {
  const BandThresholds({
    this.strongAtLeast = 0.8,
    this.developingAtLeast = 0.5,
  });

  final double strongAtLeast;
  final double developingAtLeast;
}

const kDefaultThresholds = BandThresholds();

/// Minimum answered items before a band is assigned, so one slip is not
/// read as a consistent difficulty.
const kMinItemsForBand = 3;

/// Classifies one skill from its item results. Returns null when there is
/// not enough evidence yet.
SkillBand? classifySkill({
  required int correct,
  required int total,
  BandThresholds thresholds = kDefaultThresholds,
}) {
  if (total < kMinItemsForBand) return null;
  final accuracy = correct / total;
  if (accuracy >= thresholds.strongAtLeast) return SkillBand.strong;
  if (accuracy >= thresholds.developingAtLeast) return SkillBand.developing;
  return SkillBand.needsSupport;
}

/// Starting practice level per band (spec section 6). Levels are 1-based and
/// tracked separately for every skill; there is no global difficulty.
int startingLevelFor(SkillBand band) => switch (band) {
  SkillBand.strong => 3,
  SkillBand.developing => 2,
  SkillBand.needsSupport => 1,
};
