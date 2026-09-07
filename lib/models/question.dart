class Question {
  final String subject;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;

  const Question({
    required this.subject,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}
