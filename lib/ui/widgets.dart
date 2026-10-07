import 'package:flutter/material.dart';

import '../core/safety_language.dart';
import '../core/skills.dart';
import 'theme.dart';

/// Shows a skill's band, or "Not assessed yet" when there is no result.
class SkillBandChip extends StatelessWidget {
  const SkillBandChip({super.key, this.band});

  final SkillBand? band;

  @override
  Widget build(BuildContext context) {
    final b = band;
    final color = b == null
        ? Theme.of(context).colorScheme.outline
        : bandColor(b);
    return Chip(
      label: Text(b?.label ?? 'Not assessed yet'),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide(color: color),
      backgroundColor: Colors.transparent,
    );
  }
}

/// The standing "this is not a diagnosis" note for adult-facing screens.
class NotADiagnosisNote extends StatelessWidget {
  const NotADiagnosisNote({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: scheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                kNotADiagnosisNote,
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Marks a screen whose real flow has not been built yet.
class ComingSoonBanner extends StatelessWidget {
  const ComingSoonBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.tertiaryContainer,
      child: ListTile(
        leading: Icon(Icons.construction, color: scheme.onTertiaryContainer),
        title: Text(
          message,
          style: TextStyle(color: scheme.onTertiaryContainer),
        ),
      ),
    );
  }
}
