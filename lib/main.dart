import 'package:flutter/material.dart';

void main() {
  runApp(const BelajarCeriaApp());
}

class BelajarCeriaApp extends StatelessWidget {
  const BelajarCeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Ceria',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F7DF3),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FF),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================
// MODEL SOAL
// =====================================================

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

// =====================================================
// BANK SOAL KELAS 1 - 6
// =====================================================

final Map<int, List<Question>> questionsByGrade = {
  1: const [
    Question(
      subject: 'Matematika',
      question: 'Berapakah 5 + 3?',
      options: ['6', '7', '8', '9'],
      answer: 2,
      explanation: '5 ditambah 3 sama dengan 8.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question: 'Lawan kata dari "besar" adalah ...',
      options: ['tinggi', 'kecil', 'panjang', 'lebar'],
      answer: 1,
      explanation: 'Lawan kata besar adalah kecil.',
    ),
    Question(
      subject: 'PKN',
      question: 'Sebelum makan sebaiknya kita ...',
      options: ['bermain', 'tidur', 'berdoa', 'berlari'],
      answer: 2,
      explanation: 'Berdoa sebelum makan adalah kebiasaan yang baik.',
    ),
    Question(
      subject: 'Logika',
      question: '🍎 + 🍎 = 4. Nilai satu 🍎 adalah ...',
      options: ['1', '2', '3', '4'],
      answer: 1,
      explanation: 'Dua apel bernilai 4, jadi satu apel bernilai 2.',
    ),
    Question(
      subject: 'IPA',
      question: 'Kita menggunakan mata untuk ...',
      options: ['mendengar', 'melihat', 'mencium', 'merasakan'],
      answer: 1,
      explanation: 'Mata digunakan untuk melihat.',
    ),
    Question(
      subject: 'Matematika',
      question: 'Angka setelah 9 adalah ...',
      options: ['8', '10', '11', '12'],
      answer: 1,
      explanation: 'Setelah angka 9 adalah 10.',
    ),
  ],

  2: const [
    Question(
      subject: 'Matematika',
      question: 'Berapakah 12 + 7?',
      options: ['17', '18', '19', '20'],
      answer: 2,
      explanation: '12 + 7 = 19.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question:
          'Kalimat yang digunakan untuk bertanya biasanya diakhiri tanda ...',
      options: ['.', ',', '?', '!'],
      answer: 2,
      explanation: 'Kalimat tanya menggunakan tanda tanya (?).',
    ),
    Question(
      subject: 'PKN',
      question: 'Contoh hidup rukun di sekolah adalah ...',
      options: [
        'bertengkar',
        'saling membantu',
        'mengejek teman',
        'merebut barang'
      ],
      answer: 1,
      explanation: 'Saling membantu membuat suasana menjadi rukun.',
    ),
    Question(
      subject: 'Logika',
      question: 'Pola: 2, 4, 6, 8, ...',
      options: ['9', '10', '11', '12'],
      answer: 1,
      explanation: 'Angka bertambah 2, jadi berikutnya adalah 10.',
    ),
    Question(
      subject: 'IPA',
      question: 'Hewan yang menghasilkan susu adalah ...',
      options: ['sapi', 'ayam', 'ikan', 'kupu-kupu'],
      answer: 0,
      explanation: 'Sapi merupakan hewan yang menghasilkan susu.',
    ),
  ],

  3: const [
    Question(
      subject: 'Matematika',
      question: '6 × 4 = ...',
      options: ['20', '22', '24', '26'],
      answer: 2,
      explanation: '6 × 4 = 24.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question: 'Ide utama dalam sebuah paragraf disebut ...',
      options: ['judul', 'gagasan pokok', 'kata tanya', 'kalimat penutup'],
      answer: 1,
      explanation: 'Ide utama disebut gagasan pokok.',
    ),
    Question(
      subject: 'PKN',
      question: 'Musyawarah dilakukan untuk mencapai ...',
      options: ['kemenangan', 'mufakat', 'hukuman', 'perselisihan'],
      answer: 1,
      explanation: 'Musyawarah bertujuan mencapai mufakat.',
    ),
    Question(
      subject: 'Logika',
      question:
          'Jika semua burung memiliki sayap dan elang adalah burung, maka elang memiliki ...',
      options: ['sirip', 'sayap', 'tanduk', 'belalai'],
      answer: 1,
      explanation: 'Elang termasuk burung sehingga memiliki sayap.',
    ),
    Question(
      subject: 'IPA',
      question: 'Tumbuhan membuat makanan melalui proses ...',
      options: [
        'fotosintesis',
        'pernapasan',
        'penguapan',
        'pembekuan'
      ],
      answer: 0,
      explanation: 'Tumbuhan membuat makanan melalui fotosintesis.',
    ),
  ],

  4: const [
    Question(
      subject: 'Matematika',
      question: '25 × 4 = ...',
      options: ['80', '90', '100', '120'],
      answer: 2,
      explanation: '25 × 4 = 100.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question: 'Kalimat yang berisi perintah disebut kalimat ...',
      options: ['tanya', 'perintah', 'berita', 'seru'],
      answer: 1,
      explanation: 'Kalimat perintah digunakan untuk meminta seseorang melakukan sesuatu.',
    ),
    Question(
      subject: 'PKN',
      question: 'Sikap menghargai perbedaan disebut ...',
      options: ['toleransi', 'egois', 'iri', 'marah'],
      answer: 0,
      explanation: 'Toleransi berarti menghargai perbedaan.',
    ),
    Question(
      subject: 'Logika',
      question: 'Pola: 3, 6, 12, 24, ...',
      options: ['30', '36', '42', '48'],
      answer: 3,
      explanation: 'Setiap angka dikali 2, jadi 24 × 2 = 48.',
    ),
    Question(
      subject: 'IPA',
      question: 'Perubahan air menjadi uap disebut ...',
      options: ['mencair', 'membeku', 'menguap', 'mengembun'],
      answer: 2,
      explanation: 'Air berubah menjadi uap melalui proses penguapan.',
    ),
  ],

  5: const [
    Question(
      subject: 'Matematika',
      question: '3/4 dari 20 adalah ...',
      options: ['10', '12', '15', '16'],
      answer: 2,
      explanation: '20 × 3/4 = 15.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question: 'Ringkasan yang baik harus memuat ...',
      options: [
        'semua kata',
        'inti informasi',
        'hanya judul',
        'opini pribadi'
      ],
      answer: 1,
      explanation: 'Ringkasan berisi inti informasi secara singkat.',
    ),
    Question(
      subject: 'PKN',
      question: 'Salah satu kewajiban siswa adalah ...',
      options: [
        'mendapat nilai tinggi',
        'menaati tata tertib',
        'memilih guru',
        'mendapat hadiah'
      ],
      answer: 1,
      explanation: 'Siswa berkewajiban menaati tata tertib sekolah.',
    ),
    Question(
      subject: 'Logika',
      question:
          'Jika A lebih tinggi dari B, dan B lebih tinggi dari C, maka ...',
      options: [
        'C paling tinggi',
        'A paling tinggi',
        'B paling rendah',
        'semuanya sama'
      ],
      answer: 1,
      explanation: 'Urutannya A > B > C, sehingga A paling tinggi.',
    ),
    Question(
      subject: 'IPA',
      question: 'Organ pernapasan utama manusia adalah ...',
      options: ['jantung', 'paru-paru', 'lambung', 'ginjal'],
      answer: 1,
      explanation: 'Manusia bernapas menggunakan paru-paru.',
    ),
  ],

  6: const [
    Question(
      subject: 'Matematika',
      question: '15% dari 200 adalah ...',
      options: ['20', '25', '30', '35'],
      answer: 2,
      explanation: '15/100 × 200 = 30.',
    ),
    Question(
      subject: 'Bahasa Indonesia',
      question: 'Kesimpulan adalah ...',
      options: [
        'awal cerita',
        'inti akhir dari pembahasan',
        'nama tokoh',
        'kalimat tanya'
      ],
      answer: 1,
      explanation: 'Kesimpulan merangkum inti pembahasan.',
    ),
    Question(
      subject: 'PKN',
      question:
          'Pancasila menjadi dasar negara Indonesia. Pancasila berfungsi sebagai ...',
      options: [
        'hiasan negara',
        'dasar negara',
        'lagu nasional',
        'bahasa daerah'
      ],
      answer: 1,
      explanation: 'Pancasila merupakan dasar negara Indonesia.',
    ),
    Question(
      subject: 'Logika',
      question:
          'Semua A adalah B. Tidak semua B adalah A. Pernyataan yang tepat adalah ...',
      options: [
        'A lebih luas dari B',
        'B lebih luas dari A',
        'A dan B pasti sama',
        'A tidak berhubungan dengan B'
      ],
      answer: 1,
      explanation:
          'Jika semua A termasuk B tetapi tidak semua B termasuk A, maka B lebih luas.',
    ),
    Question(
      subject: 'IPA',
      question: 'Gaya yang menyebabkan benda jatuh ke bumi disebut gaya ...',
      options: ['gesek', 'magnet', 'gravitasi', 'pegas'],
      answer: 2,
      explanation: 'Gaya gravitasi menarik benda menuju bumi.',
    ),
  ],
};

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedGrade = 1;
  int totalScore = 0;
  int gamesPlayed = 0;

  void startQuiz({String? subject}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: selectedGrade,
          subject: subject,
          onFinished: (score) {
            setState(() {
              totalScore += score;
              gamesPlayed++;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 220,
            color: const Color(0xFF173B7A),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFFFD85C),
                          child: Text(
                            '🚀',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Belajar\nCeria',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    sidebarItem(Icons.home, 'Beranda', true),
                    sidebarItem(Icons.menu_book, 'Materi', false),
                    sidebarItem(Icons.extension, 'Kuis', false),
                    sidebarItem(Icons.emoji_events, 'Peringkat', false),
                    sidebarItem(Icons.person, 'Profil', false),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kelas Aktif',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Kelas $selectedGrade SD',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const LinearProgressIndicator(
                            value: .7,
                            minHeight: 7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Halo, Sobat Belajar! 👋',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Yuk Belajar Sambil Bermain!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // HERO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4F7DF3),
                            Color(0xFF6D5CE7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '🎯 TANTANGAN HARI INI',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  'Siap jadi\nAnak Hebat?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  'Jawab soal dan kumpulkan poin!',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                ElevatedButton(
                                  onPressed: () => startQuiz(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        const Color(0xFF4F7DF3),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    'Mulai Bermain 🚀',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Text(
                            '🧑‍🚀',
                            style: TextStyle(fontSize: 100),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // PILIH KELAS
                    const Text(
                      'Pilih Kelas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 12,
                      children: List.generate(
                        6,
                        (index) {
                          final grade = index + 1;
                          final active = grade == selectedGrade;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGrade = grade;
                              });
                            },
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 250),
                              width: 100,
                              height: 85,
                              decoration: BoxDecoration(
                                color: active
                                    ? const Color(0xFF4F7DF3)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(.06),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Kelas',
                                    style: TextStyle(
                                      color: active
                                          ? Colors.white70
                                          : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '$grade',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: active
                                          ? Colors.white
                                          : const Color(0xFF4F7DF3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // STATISTIK
                    Row(
                      children: [
                        statCard(
                          '🏆',
                          'Total Poin',
                          '$totalScore',
                        ),
                        const SizedBox(width: 15),
                        statCard(
                          '🎮',
                          'Permainan',
                          '$gamesPlayed',
                        ),
                        const SizedBox(width: 15),
                        statCard(
                          '⭐',
                          'Kelas',
                          '$selectedGrade',
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Materi & Tantangan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        subjectCard(
                          '🔢',
                          'Matematika',
                        ),
                        subjectCard(
                          '📚',
                          'Bahasa Indonesia',
                        ),
                        subjectCard(
                          '🇮🇩',
                          'PKN',
                        ),
                        subjectCard(
                          '🧠',
                          'Logika',
                        ),
                        subjectCard(
                          '🔬',
                          'IPA',
                        ),
                        subjectCard(
                          '🌍',
                          'IPS',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebarItem(
    IconData icon,
    String title,
    bool active,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: active
            ? Colors.white.withOpacity(.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget statCard(
    String emoji,
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget subjectCard(
    String emoji,
    String title,
  ) {
    return GestureDetector(
      onTap: () {
        startQuiz(subject: title);
      },
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 38),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Kelas $selectedGrade • Mulai',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// QUIZ PAGE
// =====================================================

class QuizPage extends StatefulWidget {
  final int grade;
  final String? subject;
  final ValueChanged<int> onFinished;

  const QuizPage({
    super.key,
    required this.grade,
    required this.onFinished,
    this.subject,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;

  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  @override
  void initState() {
    super.initState();

    final allQuestions =
        questionsByGrade[widget.grade] ?? [];

    if (widget.subject == null) {
      questions = [...allQuestions];
      questions.shuffle();
    } else {
      questions = allQuestions
          .where(
            (question) =>
                question.subject == widget.subject,
          )
          .toList();
    }
  }

  void chooseAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == questions[currentQuestion].answer) {
        score += 10;
      }
    });
  }

  void nextQuestion() {
    if (!answered) return;

    if (currentQuestion ==
        questions.length - 1) {
      widget.onFinished(score);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            grade: widget.grade,
            score: score,
            total: questions.length * 10,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kuis'),
        ),
        body: const Center(
          child: Text(
            'Soal untuk mata pelajaran ini belum tersedia.',
          ),
        ),
      );
    }

    final question =
        questions[currentQuestion];

    final progress =
        (currentQuestion + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Kelas ${widget.grade} SD',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // PROGRESS
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentQuestion + 1}/${questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // PERTANYAAN
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD85C),
                      Color(0xFFFFB65C),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(
                      question.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF745300),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // JAWABAN
              ...List.generate(
                question.options.length,
                (index) {
                  final correct =
                      index == question.answer;

                  final selected =
                      index == selectedAnswer;

                  final showCorrect =
                      answered && correct;

                  final showWrong =
                      answered &&
                          selected &&
                          !correct;

                  return GestureDetector(
                    onTap: () => chooseAnswer(index),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(bottom: 13),
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: showCorrect
                            ? const Color(0xFFE0F7E8)
                            : showWrong
                                ? const Color(0xFFFFE3E3)
                                : Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: showCorrect
                              ? Colors.green
                              : showWrong
                                  ? Colors.red
                                  : const Color(
                                      0xFFE0E6F2,
                                    ),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                showCorrect
                                    ? Colors.green
                                    : showWrong
                                        ? Colors.red
                                        : const Color(
                                            0xFFEAF0FF,
                                          ),
                            child: Text(
                              String.fromCharCode(
                                65 + index,
                              ),
                              style: TextStyle(
                                color:
                                    showCorrect ||
                                            showWrong
                                        ? Colors.white
                                        : const Color(
                                            0xFF4F7DF3,
                                          ),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                          if (showCorrect)
                            const Text('🎉'),

                          if (showWrong)
                            const Text('😅'),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // FEEDBACK
              if (answered)
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedAnswer ==
                                  question.answer
                              ? '🎉'
                              : '💡',
                          style:
                              const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedAnswer ==
                                    question.answer
                                ? 'Jawaban benar! ${question.explanation}'
                                : 'Belum tepat. ${question.explanation}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // NEXT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      answered ? nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    backgroundColor:
                        const Color(0xFF4F7DF3),
                    foregroundColor: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    currentQuestion ==
                            questions.length - 1
                        ? 'Lihat Nilai 🏆'
                        : 'Soal Berikutnya ➜',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// RESULT PAGE
// =====================================================

class ResultPage extends StatelessWidget {
  final int grade;
  final int score;
  final int total;

  const ResultPage({
    super.key,
    required this.grade,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent =
        total == 0
            ? 0
            : ((score / total) * 100).round();

    final stars =
        percent >= 80
            ? 3
            : percent >= 60
                ? 2
                : 1;

    String message;

    if (percent >= 80) {
      message = 'Hebat sekali! Kamu luar biasa! 🎉';
    } else if (percent >= 60) {
      message = 'Bagus! Terus tingkatkan lagi! 💪';
    } else {
      message = 'Tidak apa-apa, ayo coba lagi! 🌟';
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text(
                  '🏆',
                  style: TextStyle(fontSize: 90),
                ),

                const Text(
                  'Kuis Selesai!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Kelas $grade SD',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 25),

                // NILAI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4F7DF3),
                        Color(0xFF6D5CE7),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Nilai Kamu',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$percent',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 75,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Text(
                        '/ 100',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '⭐' * stars,
                        style:
                            const TextStyle(fontSize: 32),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: resultCard(
                        'Poin',
                        '$score',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: resultCard(
                        'Persentase',
                        '$percent%',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4F7DF3),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget resultCard(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}