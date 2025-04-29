class Note {
  final int id;
  final int sessionId;
  final int goalId;
  final String bodyText;
  final bool useScore;
  final int scoreNumerator;
  final int scoreDenominator;

  const Note({ 
    required this.id,
    required this.sessionId,
    required this.bodyText,
    required this.useScore,
    required this.scoreNumerator,
    required this.scoreDenominator,
    this.goalId = 0
  });

  factory Note.fromSqfliteDatabase(Map<String,dynamic> map) => Note(
    id: map['id']?.toInt() ?? 0,
    sessionId: map['sessionId'] ?? 0,
    goalId: map['goalId'] ?? 0,
    bodyText: map['bodyText'] ?? '',
    useScore: map['useScore'] == 1 ? true : false,
    scoreNumerator: map['scoreNumerator'] ?? 0,
    scoreDenominator: map['scoreDenominator'] ?? 0,
  );
}