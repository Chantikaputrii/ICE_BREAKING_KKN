class ScoreRecord {
  const ScoreRecord({
    required this.name,
    required this.grade,
    required this.score,
    required this.total,
    required this.completedAt,
  });

  final String name;
  final int grade;
  final int score;
  final int total;
  final DateTime completedAt;

  int get percentage => total == 0 ? 0 : ((score / total) * 100).round();

  Map<String, dynamic> toJson() => {
        'name': name,
        'grade': grade,
        'score': score,
        'total': total,
        'completedAt': completedAt.toIso8601String(),
      };

  factory ScoreRecord.fromJson(Map<String, dynamic> json) => ScoreRecord(
        name: json['name'] as String,
        grade: json['grade'] as int,
        score: json['score'] as int,
        total: json['total'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}
