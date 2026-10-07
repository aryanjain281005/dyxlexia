import 'package:flutter/material.dart';

import '../core/skills.dart';

/// High-contrast, large-target theme (spec section 9, Accessibility).
ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1B5E20),
    contrastLevel: 0.5,
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.comfortable,
    textTheme: Typography.material2021().black.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 12),
  );
}

/// Neutral, non-alarming colours for profile bands. "Needs Support" is
/// amber, not red: it means "practise this more", not "something is wrong".
Color bandColor(SkillBand band) => switch (band) {
  SkillBand.strong => const Color(0xFF2E7D32),
  SkillBand.developing => const Color(0xFF1565C0),
  SkillBand.needsSupport => const Color(0xFFB26A00),
};
