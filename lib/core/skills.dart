/// The six literacy parameters Akshara Path measures (spec section 4).
///
/// Each parameter is scored and adapted independently. The app reports a
/// skill profile; it never produces a diagnosis or a single combined score.
enum Skill {
  phonologicalAwareness(
    id: 'phonological_awareness',
    label: 'Phonological Awareness',
    measures: 'Hearing, blending, segmenting and changing sounds in words.',
    errorTags: [
      ErrorTag.wrongInitialSound,
      ErrorTag.failedBlend,
      ErrorTag.failedSegmentation,
      ErrorTag.wrongSoundDeletionOrSubstitution,
    ],
  ),
  graphemePhoneme(
    id: 'grapheme_phoneme',
    label: 'Grapheme–Phoneme Correspondence',
    measures: 'Linking written aksharas and matras to their sounds.',
    errorTags: [
      ErrorTag.wrongGrapheme,
      ErrorTag.matraConfusion,
      ErrorTag.similarSymbolConfusion,
    ],
  ),
  decoding(
    id: 'decoding',
    label: 'Decoding',
    measures: 'Blending written sound units into a spoken word.',
    errorTags: [
      ErrorTag.skippedUnit,
      ErrorTag.incorrectBlend,
      ErrorTag.hesitation,
      ErrorTag.repeatedDecodingFailure,
    ],
  ),
  wordRecognition(
    id: 'word_recognition',
    label: 'Word Recognition',
    measures: 'Quickly and accurately recognising familiar written words.',
    errorTags: [
      ErrorTag.wrongFamiliarWord,
      ErrorTag.visualConfusion,
      ErrorTag.slowResponse,
    ],
  ),
  spellingWriting(
    id: 'spelling_writing',
    label: 'Spelling / Writing',
    measures: 'Building or writing words from sounds and written units.',
    errorTags: [
      ErrorTag.wrongMatra,
      ErrorTag.missingUnit,
      ErrorTag.extraUnit,
      ErrorTag.wrongConsonant,
      ErrorTag.swappedOrder,
      ErrorTag.wrongConjunct,
    ],
  ),
  readingComprehension(
    id: 'reading_comprehension',
    label: 'Reading Comprehension',
    measures:
        'Understanding detail, sequence, cause and effect, and inference.',
    errorTags: [
      ErrorTag.wrongDetail,
      ErrorTag.sequenceError,
      ErrorTag.causeEffectError,
      ErrorTag.inferenceError,
      ErrorTag.predictionError,
    ],
  );

  const Skill({
    required this.id,
    required this.label,
    required this.measures,
    required this.errorTags,
  });

  /// Stable identifier used in SQLite rows and language-pack JSON.
  final String id;
  final String label;
  final String measures;
  final List<ErrorTag> errorTags;

  static Skill fromId(String id) => values.firstWhere(
    (s) => s.id == id,
    orElse: () {
      throw ArgumentError.value(id, 'id', 'Unknown skill');
    },
  );
}

/// Profile band for one skill (spec section 4). Thresholds live in
/// `scoring.dart` and are placeholders until validation.
enum SkillBand {
  strong(id: 'strong', label: 'Strong'),
  developing(id: 'developing', label: 'Developing'),
  needsSupport(id: 'needs_support', label: 'Needs Support');

  const SkillBand({required this.id, required this.label});

  final String id;
  final String label;

  static SkillBand fromId(String id) => values.firstWhere((b) => b.id == id);
}

/// What went wrong on an item, not just whether it was wrong (spec section 7).
enum ErrorTag {
  wrongInitialSound('wrong_initial_sound', 'Wrong initial sound'),
  failedBlend('failed_blend', 'Failed blend'),
  failedSegmentation('failed_segmentation', 'Failed segmentation'),
  wrongSoundDeletionOrSubstitution(
    'wrong_sound_deletion_substitution',
    'Wrong sound deletion/substitution',
  ),
  wrongGrapheme('wrong_grapheme', 'Wrong grapheme'),
  matraConfusion('matra_confusion', 'Matra confusion'),
  similarSymbolConfusion(
    'similar_symbol_confusion',
    'Similar-symbol confusion',
  ),
  skippedUnit('skipped_unit', 'Skipped unit'),
  incorrectBlend('incorrect_blend', 'Incorrect blend'),
  hesitation('hesitation', 'Hesitation'),
  repeatedDecodingFailure(
    'repeated_decoding_failure',
    'Repeated decoding failure',
  ),
  wrongFamiliarWord('wrong_familiar_word', 'Wrong familiar word'),
  visualConfusion('visual_confusion', 'Visual confusion'),
  slowResponse('slow_response', 'Slow response'),
  wrongMatra('wrong_matra', 'Wrong matra'),
  missingUnit('missing_unit', 'Missing unit'),
  extraUnit('extra_unit', 'Extra unit'),
  wrongConsonant('wrong_consonant', 'Wrong consonant'),
  swappedOrder('swapped_order', 'Swapped order'),
  wrongConjunct('wrong_conjunct', 'Wrong conjunct'),
  wrongDetail('wrong_detail', 'Wrong detail'),
  sequenceError('sequence_error', 'Sequence error'),
  causeEffectError('cause_effect_error', 'Cause/effect error'),
  inferenceError('inference_error', 'Inference error'),
  predictionError('prediction_error', 'Prediction error');

  const ErrorTag(this.id, this.label);

  final String id;
  final String label;

  static ErrorTag fromId(String id) => values.firstWhere((t) => t.id == id);
}
