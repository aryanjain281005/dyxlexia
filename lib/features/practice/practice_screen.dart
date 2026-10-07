import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../core/games.dart';
import '../../core/skills.dart';
import '../../ui/widgets.dart';

/// Daily practice. Placeholder: shows the 11 games grouped by the skill
/// that owns each one, with the MVP demo set marked.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pack = AppServices.of(context).languagePack;
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ComingSoonBanner(message: 'Games are not playable yet.'),
          for (final skill in Skill.values) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
              child: Text(
                '${skill.label} · ${pack.skillNames[skill] ?? ''}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final game in gamesForSkill(skill))
              Card(
                child: ListTile(
                  leading: const Icon(Icons.videogame_asset_outlined),
                  title: Text(game.name),
                  subtitle: Text(game.mechanic),
                  trailing: game.inMvpDemo
                      ? const Chip(label: Text('Demo'))
                      : null,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
