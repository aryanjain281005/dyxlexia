import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../core/skills.dart';
import '../../language_packs/language_pack.dart';
import '../../ui/widgets.dart';

/// Weekly recheck with fresh items. Placeholder: shows how many reassessment
/// items exist per skill. These items are never used in practice.
class ReassessmentScreen extends StatelessWidget {
  const ReassessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pack = AppServices.of(context).languagePack;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly recheck')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ComingSoonBanner(
            message: 'The weekly recheck is not built yet.',
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'After a week of practice, the child sees new words and stories '
              'that test the same skills, so improvement reflects real learning '
              'rather than remembering answers.',
            ),
          ),
          for (final skill in Skill.values)
            Card(
              child: ListTile(
                title: Text(skill.label),
                trailing: Text(
                  '${pack.itemsFor(skill, ItemPool.reassessment).length} fresh items',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
