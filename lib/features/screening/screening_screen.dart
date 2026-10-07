import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../core/skills.dart';
import '../../language_packs/language_pack.dart';
import '../../ui/widgets.dart';

/// Initial skill check across the six parameters. Placeholder: lists what
/// will be measured and how many baseline items the language pack provides.
class ScreeningScreen extends StatelessWidget {
  const ScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pack = AppServices.of(context).languagePack;
    return Scaffold(
      appBar: AppBar(title: const Text('Skill check')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ComingSoonBanner(
            message: 'The skill-check activities are not built yet.',
          ),
          const NotADiagnosisNote(),
          const SizedBox(height: 8),
          for (final skill in Skill.values)
            Card(
              child: ListTile(
                title: Text(skill.label),
                subtitle: Text(
                  '${pack.skillNames[skill] ?? ''}\n${skill.measures}',
                ),
                isThreeLine: true,
                trailing: Text(
                  '${pack.itemsFor(skill, ItemPool.baseline).length} items',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
