import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../core/skills.dart';
import '../../ui/widgets.dart';

/// Adult-facing progress view. Placeholder: shows the latest band for each
/// skill from the local database, or "Not assessed yet".
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<Map<Skill, SkillBand>>? _bands;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bands ??= _load();
  }

  Future<Map<Skill, SkillBand>> _load() async {
    final db = AppServices.of(context).database;
    final child = await db.activeChild();
    if (child == null) return const {};
    return db.latestBands(child.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: FutureBuilder<Map<Skill, SkillBand>>(
        future: _bands,
        builder: (context, snap) {
          final bands = snap.data ?? const {};
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const ComingSoonBanner(
                message: 'Baseline vs. latest comparison and next-week plan are not built yet.',
              ),
              const NotADiagnosisNote(),
              const SizedBox(height: 8),
              for (final skill in Skill.values)
                Card(
                  child: ListTile(
                    title: Text(skill.label),
                    trailing: SkillBandChip(band: bands[skill]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
