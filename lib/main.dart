import 'package:flutter/material.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'language_packs/language_pack.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase.open();
  // Hindi is the first bundled pack; language selection comes with adult setup.
  final pack = await loadLanguagePack(kBundledLanguages.first);
  runApp(AksharaPathApp(database: database, languagePack: pack));
}
