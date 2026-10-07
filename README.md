# Akshara Path

An offline-first, multilingual, gamified literacy companion for children in
India (about 6–10 years). It measures six foundational reading and writing
skills, turns the results into personalised practice, and rechecks progress
every week with fresh items.

Akshara Path is **not** a diagnostic tool. It reports which skills are
*Strong*, *Developing* or *Need Support*; it never labels a child or produces
a dyslexia score.

## Status

Scaffold only. The home screen and the four sections (skill check, practice,
progress, weekly recheck) exist as placeholders on top of the real data model,
local database and Hindi language pack. Games and the assessment flow come next.

## Layout

```
lib/
  core/            Engine-level model shared by every language
    skills.dart      Six skills, bands, error tags
    games.dart       The 11 games, each owned by one skill
    scoring.dart     Placeholder band thresholds and starting levels
    safety_language.dart  Wording the app must never use
  data/            SQLite storage (sqflite), all local to the device
  language_packs/  Language-pack model and loader
  features/        Screens: home, screening, practice, progress, reassessment
  ui/              Theme and shared widgets
assets/language_packs/
  hi/pack.json     Hindi: script inventory, items (baseline / practice /
                   reassessment pools), stories, child-facing skill names
```

Adding a language means adding `assets/language_packs/<code>/pack.json`, listing
it in `pubspec.yaml`, and adding the code to `kBundledLanguages`. The engine does
not change.

The Hindi items are draft sample content and need review by a native-speaker
educator. Audio paths in the pack point at clips that have not been recorded yet.

## Run

Requires Flutter 3.47 (stable) and the Android SDK.

```
flutter pub get
flutter run          # on a connected Android device or emulator
flutter test
flutter build apk --debug
```

CI (`.github/workflows/flutter.yml`) runs format, analyze, tests and a debug APK
build on every pull request; the APK is uploaded as a build artifact.
