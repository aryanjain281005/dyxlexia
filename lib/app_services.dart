import 'package:flutter/widgets.dart';

import 'data/app_database.dart';
import 'language_packs/language_pack.dart';

/// App-wide dependencies, created once at startup and read by screens with
/// `AppServices.of(context)`.
class AppServices extends InheritedWidget {
  const AppServices({
    super.key,
    required this.database,
    required this.languagePack,
    required super.child,
  });

  final AppDatabase database;
  final LanguagePack languagePack;

  static AppServices of(BuildContext context) {
    final services = context.dependOnInheritedWidgetOfExactType<AppServices>();
    assert(services != null, 'AppServices missing above $context');
    return services!;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) =>
      database != oldWidget.database || languagePack != oldWidget.languagePack;
}
