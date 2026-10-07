/// Wording the app must never show (spec section 2, "Safety language").
///
/// Tests scan UI strings and language packs against this list.
const List<String> kForbiddenPhrases = [
  'has dyslexia',
  'is dyslexic',
  'diagnosed',
  'diagnosis:',
  'dyslexia score',
  'dyslexia risk',
  'cures dyslexia',
  'treats dyslexia',
  'fixes dyslexia',
];

/// Standing note shown to adults wherever results appear.
const String kNotADiagnosisNote =
    'Akshara Path shows which reading and writing skills need more practice. '
    'It is not a medical or diagnostic test. If difficulty continues, consider '
    'talking with a teacher, special educator or other professional.';
