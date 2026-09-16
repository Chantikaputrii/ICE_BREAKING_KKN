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

  Question withOptions(List<String> newOptions) {
    // Cari posisi baru dari jawaban yang benar berdasarkan
    // teksnya. Kalau karena suatu sebab teksnya tidak
    // ditemukan (mis. data soal tidak konsisten), jangan
    // sampai index-nya jadi -1 (tidak valid) karena itu bisa
    // membuat layar error merah saat soal ditampilkan.
    final matchedIndex = newOptions.indexOf(
      options[answer],
    );

    final safeAnswer = matchedIndex >= 0
        ? matchedIndex
        : answer.clamp(0, newOptions.length - 1);

    return Question(
      id: id,
      subject: subject,
      question: question,
      options: newOptions,
      answer: safeAnswer,
      explanation: explanation,
      visual: visual,
      isAnimated: isAnimated,
    );
  }
}