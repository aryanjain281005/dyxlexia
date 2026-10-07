import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../data/app_database.dart';
import '../practice/practice_screen.dart';
import '../progress/progress_screen.dart';
import '../reassessment/reassessment_screen.dart';
import '../screening/screening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<ChildProfile?>? _child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _child ??= AppServices.of(context).database.activeChild();
  }

  @override
  Widget build(BuildContext context) {
    final pack = AppServices.of(context).languagePack;
    return Scaffold(
      appBar: AppBar(title: const Text('Akshara Path')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('अक्षर पथ', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Test. Understand. Personalize. Play. Improve. Repeat.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FutureBuilder<ChildProfile?>(
            future: _child,
            builder: (context, snap) {
              final child = snap.data;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.child_care, size: 32),
                  title: Text(child?.nickname ?? 'No child profile yet'),
                  subtitle: Text(
                    child == null
                        ? 'Adult setup comes first. Language: ${pack.name} (${pack.nativeName})'
                        : 'Language: ${pack.name} (${pack.nativeName})',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _NavCard(
            icon: Icons.fact_check_outlined,
            title: 'Skill check',
            subtitle: 'Short activities across six reading and writing skills',
            destination: const ScreeningScreen(),
          ),
          _NavCard(
            icon: Icons.sports_esports_outlined,
            title: 'Practice',
            subtitle: 'About 10 minutes a day of games chosen for each skill',
            destination: const PracticeScreen(),
          ),
          _NavCard(
            icon: Icons.insights_outlined,
            title: 'Progress',
            subtitle: 'Skill profile and what changed since last time',
            destination: const ProgressScreen(),
          ),
          _NavCard(
            icon: Icons.event_repeat_outlined,
            title: 'Weekly recheck',
            subtitle: 'Fresh items to see real improvement',
            destination: const ReassessmentScreen(),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.destination,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => destination)),
      ),
    );
  }
}
