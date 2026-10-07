import 'package:flutter/material.dart';

import 'app_services.dart';
import 'data/app_database.dart';
import 'features/home/home_screen.dart';
import 'language_packs/language_pack.dart';
import 'ui/theme.dart';

class AksharaPathApp extends StatelessWidget {
  const AksharaPathApp({
    super.key,
    required this.database,
    required this.languagePack,
  });

  final AppDatabase database;
  final LanguagePack languagePack;

  @override
  Widget build(BuildContext context) {
    return AppServices(
      database: database,
      languagePack: languagePack,
      child: MaterialApp(
        title: 'Akshara Path',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
