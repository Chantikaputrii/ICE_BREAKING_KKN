class Question {
  final String id;
  final String subject;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final String? visual;
  final bool isAnimated;

  const Question({
    this.id = '',
    required this.subject,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    this.visual,
    this.isAnimated = false,
  });

  Question withOptions(List<String> newOptions) => Question(
        id: id,
        subject: subject,
        question: question,
        options: newOptions,
        answer: newOptions.indexOf(options[answer]),
        explanation: explanation,
        visual: visual,
        isAnimated: isAnimated,
      );
}
