import '../models/question.dart';

/// ============================================================
/// BANK SOAL
/// 6 KELAS × 50 SOAL = 300 SOAL
///
/// Setiap kelas:
/// - 20 Matematika
/// - 10 Bahasa Indonesia
/// - 10 IPA
/// - 10 Logika
///
/// Pretest:
/// - Hanya mengambil 10 soal
/// - Soal diacak berdasarkan nama siswa
/// - Urutan pilihan jawaban juga diacak
/// ============================================================

final Map<int, List<Question>> questionsByGrade = {
  for (var grade = 1; grade <= 6; grade++)
    grade: _questionsForGrade(grade),
};

/// ============================================================
/// PRETEST 10 SOAL
/// ============================================================

List<Question> getPretestQuestions({
  required int grade,
  required String studentName,
}) {
  final allQuestions = List<Question>.from(
    questionsByGrade[grade] ?? const <Question>[],
  );

  if (allQuestions.length < 10) {
    return allQuestions;
  }

  final seed = _createSeed(studentName, grade);

  _seededShuffle(allQuestions, seed);

  final selected = allQuestions.take(10).toList();

  return [
    for (var i = 0; i < selected.length; i++)
      _shuffleQuestionOptions(
        selected[i],
        seed + i + 1,
      ),
  ];
}

/// Membuat seed berbeda berdasarkan nama siswa + kelas.
int _createSeed(String studentName, int grade) {
  var hash = 0;

  final name = studentName.trim().toLowerCase();

  for (var i = 0; i < name.length; i++) {
    hash = ((hash * 31) + name.codeUnitAt(i)) & 0x7fffffff;
  }

  return (hash + grade * 1000003) & 0x7fffffff;
}

/// Shuffle sederhana tetapi konsisten berdasarkan seed.
void _seededShuffle<T>(List<T> list, int seed) {
  var currentSeed = seed;

  for (var i = list.length - 1; i > 0; i--) {
    currentSeed =
        (currentSeed * 1103515245 + 12345) & 0x7fffffff;

    final j = currentSeed % (i + 1);

    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
}

/// Mengacak pilihan jawaban dan memperbarui index jawaban benar.
Question _shuffleQuestionOptions(
  Question question,
  int seed,
) {
  final options = List<String>.from(question.options);

  final correctAnswer = options[question.answer];

  _seededShuffle(options, seed);

  return Question(
    id: question.id,
    subject: question.subject,
    question: question.question,
    options: options,
    answer: options.indexOf(correctAnswer),
    explanation: question.explanation,
    visual: question.visual,
    isAnimated: question.isAnimated,
  );
}

/// ============================================================
/// PEMBUAT 50 SOAL SETIAP KELAS
/// ============================================================

List<Question> _questionsForGrade(int grade) {
  return [
    ...List.generate(
      20,
      (index) => _mathQuestion(grade, index),
    ),

    ...List.generate(
      10,
      (index) => _languageQuestion(grade, index),
    ),

    ...List.generate(
      10,
      (index) => _scienceQuestion(grade, index),
    ),

    ...List.generate(
      10,
      (index) => _logicQuestion(grade, index),
    ),
  ];
}

/// ============================================================
/// FUNGSI PEMBUAT SOAL
/// ============================================================

Question _makeQuestion({
  required String id,
  required String subject,
  required String question,
  required String correct,
  required List<String> wrong,
  required String explanation,
  String? visual,
  bool isAnimated = false,
}) {
  return Question(
    id: id,
    subject: subject,
    question: question,
    options: [
      correct,
      ...wrong,
    ],
    answer: 0,
    explanation: explanation,
    visual: visual,
    isAnimated: isAnimated,
  );
}

/// ============================================================
/// MATEMATIKA
/// ============================================================

Question _mathQuestion(int grade, int index) {
  final item = _mathData(grade)[index];

  return _makeQuestion(
    id: 'k$grade-m$index',
    subject: 'Matematika',
    question: item[0],
    correct: item[1],
    wrong: [
      item[2],
      item[3],
      item[4],
    ],
    explanation: 'Jawaban yang tepat adalah ${item[1]}.',
    visual: '🔢',
    isAnimated: index % 4 == 0,
  );
}

List<List<String>> _mathData(int grade) {
  switch (grade) {
    // ========================================================
    // KELAS 1 - MATEMATIKA
    // ========================================================

    case 1:
      return const [
        [
          'Ada 2 apel lalu datang 3 apel lagi. Jumlah apel semuanya adalah ...',
          '5',
          '6',
          '7',
          '4'
        ],
        [
          'Ada 3 apel lalu datang 5 apel lagi. Jumlah apel semuanya adalah ...',
          '8',
          '9',
          '10',
          '7'
        ],
        [
          'Ada 4 pensil lalu diberikan 2 pensil. Sisa pensil adalah ...',
          '2',
          '3',
          '4',
          '1'
        ],
        [
          'Ada 6 permen lalu dimakan 3. Sisa permen adalah ...',
          '3',
          '2',
          '4',
          '5'
        ],
        [
          '5 + 4 = ...',
          '9',
          '8',
          '10',
          '7'
        ],
        [
          '7 - 2 = ...',
          '5',
          '4',
          '6',
          '3'
        ],
        [
          '1 + 6 = ...',
          '7',
          '8',
          '6',
          '5'
        ],
        [
          '9 - 4 = ...',
          '5',
          '6',
          '4',
          '3'
        ],
        [
          '3 + 4 = ...',
          '7',
          '6',
          '8',
          '5'
        ],
        [
          '8 - 5 = ...',
          '3',
          '4',
          '2',
          '5'
        ],
        [
          '2 + 7 = ...',
          '9',
          '8',
          '10',
          '7'
        ],
        [
          '10 - 3 = ...',
          '7',
          '6',
          '8',
          '5'
        ],
        [
          '4 + 4 = ...',
          '8',
          '7',
          '9',
          '6'
        ],
        [
          '9 - 6 = ...',
          '3',
          '2',
          '4',
          '5'
        ],
        [
          '5 + 2 = ...',
          '7',
          '6',
          '8',
          '5'
        ],
        [
          '8 - 2 = ...',
          '6',
          '5',
          '7',
          '4'
        ],
        [
          '1 + 8 = ...',
          '9',
          '7',
          '10',
          '8'
        ],
        [
          '10 - 7 = ...',
          '3',
          '2',
          '4',
          '5'
        ],
        [
          '6 + 2 = ...',
          '8',
          '7',
          '9',
          '6'
        ],
        [
          '7 - 5 = ...',
          '2',
          '3',
          '1',
          '4'
        ],
      ];

    // ========================================================
    // KELAS 2 - MATEMATIKA
    // ========================================================

    case 2:
      return const [
        [
          'Rani memiliki 17 stiker. Ia memberikan 3 stiker. Sisa stikernya ...',
          '14',
          '15',
          '16',
          '13'
        ],
        [
          '25 + 13 = ...',
          '38',
          '37',
          '39',
          '36'
        ],
        [
          '42 - 15 = ...',
          '27',
          '28',
          '26',
          '25'
        ],
        [
          '31 + 18 = ...',
          '49',
          '48',
          '50',
          '47'
        ],
        [
          '50 - 24 = ...',
          '26',
          '25',
          '27',
          '28'
        ],
        [
          '23 + 16 = ...',
          '39',
          '38',
          '40',
          '37'
        ],
        [
          '45 - 17 = ...',
          '28',
          '27',
          '29',
          '26'
        ],
        [
          '14 + 25 = ...',
          '39',
          '38',
          '40',
          '37'
        ],
        [
          '36 - 18 = ...',
          '18',
          '17',
          '19',
          '16'
        ],
        [
          '27 + 12 = ...',
          '39',
          '38',
          '40',
          '37'
        ],
        [
          '48 - 23 = ...',
          '25',
          '24',
          '26',
          '27'
        ],
        [
          '19 + 21 = ...',
          '40',
          '39',
          '41',
          '38'
        ],
        [
          '55 - 30 = ...',
          '25',
          '24',
          '26',
          '27'
        ],
        [
          '16 + 27 = ...',
          '43',
          '42',
          '44',
          '41'
        ],
        [
          '60 - 28 = ...',
          '32',
          '31',
          '33',
          '34'
        ],
        [
          '34 + 15 = ...',
          '49',
          '48',
          '50',
          '47'
        ],
        [
          '47 - 19 = ...',
          '28',
          '27',
          '29',
          '26'
        ],
        [
          '28 + 14 = ...',
          '42',
          '41',
          '43',
          '40'
        ],
        [
          '52 - 26 = ...',
          '26',
          '25',
          '27',
          '28'
        ],
        [
          '37 + 12 = ...',
          '49',
          '48',
          '50',
          '47'
        ],
      ];

    // ========================================================
    // KELAS 3 - MATEMATIKA
    // ========================================================

    case 3:
      return const [
        [
          '3 × 5 = ...',
          '15',
          '16',
          '14',
          '13'
        ],
        [
          '4 × 6 = ...',
          '24',
          '25',
          '23',
          '22'
        ],
        [
          '7 × 3 = ...',
          '21',
          '20',
          '22',
          '24'
        ],
        [
          '8 × 4 = ...',
          '32',
          '31',
          '33',
          '34'
        ],
        [
          '6 × 7 = ...',
          '42',
          '41',
          '43',
          '40'
        ],
        [
          '9 × 5 = ...',
          '45',
          '44',
          '46',
          '40'
        ],
        [
          '7 × 8 = ...',
          '56',
          '55',
          '57',
          '54'
        ],
        [
          '4 × 9 = ...',
          '36',
          '35',
          '37',
          '34'
        ],
        [
          '8 × 6 = ...',
          '48',
          '47',
          '49',
          '46'
        ],
        [
          '5 × 7 = ...',
          '35',
          '34',
          '36',
          '37'
        ],
        [
          '9 × 6 = ...',
          '54',
          '53',
          '55',
          '52'
        ],
        [
          '7 × 7 = ...',
          '49',
          '48',
          '50',
          '47'
        ],
        [
          '8 × 8 = ...',
          '64',
          '63',
          '65',
          '62'
        ],
        [
          '6 × 9 = ...',
          '54',
          '53',
          '55',
          '52'
        ],
        [
          '3 × 8 = ...',
          '24',
          '23',
          '25',
          '22'
        ],
        [
          '7 × 4 = ...',
          '28',
          '27',
          '29',
          '26'
        ],
        [
          '9 × 7 = ...',
          '63',
          '62',
          '64',
          '61'
        ],
        [
          '5 × 8 = ...',
          '40',
          '39',
          '41',
          '38'
        ],
        [
          '6 × 6 = ...',
          '36',
          '35',
          '37',
          '34'
        ],
        [
          '9 × 8 = ...',
          '72',
          '71',
          '73',
          '70'
        ],
      ];

    // ========================================================
    // KELAS 4 - MATEMATIKA
    // ========================================================

    case 4:
      return const [
        [
          '12 ÷ 3 = ...',
          '4',
          '5',
          '6',
          '3'
        ],
        [
          '20 ÷ 4 = ...',
          '5',
          '6',
          '7',
          '4'
        ],
        [
          '30 ÷ 5 = ...',
          '6',
          '7',
          '8',
          '5'
        ],
        [
          '42 ÷ 6 = ...',
          '7',
          '8',
          '9',
          '6'
        ],
        [
          '56 ÷ 7 = ...',
          '8',
          '9',
          '10',
          '7'
        ],
        [
          '72 ÷ 8 = ...',
          '9',
          '10',
          '11',
          '8'
        ],
        [
          '20 ÷ 2 = ...',
          '10',
          '11',
          '12',
          '9'
        ],
        [
          '33 ÷ 3 = ...',
          '11',
          '12',
          '13',
          '10'
        ],
        [
          '36 ÷ 4 = ...',
          '9',
          '8',
          '10',
          '7'
        ],
        [
          '45 ÷ 5 = ...',
          '9',
          '10',
          '11',
          '8'
        ],
        [
          '54 ÷ 6 = ...',
          '9',
          '8',
          '10',
          '7'
        ],
        [
          '63 ÷ 7 = ...',
          '9',
          '8',
          '10',
          '11'
        ],
        [
          '64 ÷ 8 = ...',
          '8',
          '7',
          '9',
          '10'
        ],
        [
          '16 ÷ 2 = ...',
          '8',
          '9',
          '10',
          '7'
        ],
        [
          '27 ÷ 3 = ...',
          '9',
          '10',
          '11',
          '8'
        ],
        [
          '40 ÷ 4 = ...',
          '10',
          '11',
          '12',
          '9'
        ],
        [
          '55 ÷ 5 = ...',
          '11',
          '12',
          '13',
          '10'
        ],
        [
          '18 ÷ 6 = ...',
          '3',
          '4',
          '5',
          '2'
        ],
        [
          '28 ÷ 7 = ...',
          '4',
          '5',
          '6',
          '3'
        ],
        [
          '40 ÷ 8 = ...',
          '5',
          '6',
          '7',
          '4'
        ],
      ];

    // ========================================================
    // KELAS 5 - MATEMATIKA
    // ========================================================

    case 5:
      return const [
        [
          'Setengah dari 24 adalah ...',
          '12',
          '13',
          '14',
          '11'
        ],
        [
          'Setengah dari 28 adalah ...',
          '14',
          '15',
          '16',
          '13'
        ],
        [
          'Setengah dari 32 adalah ...',
          '16',
          '17',
          '18',
          '15'
        ],
        [
          'Seperempat dari 36 adalah ...',
          '9',
          '10',
          '11',
          '8'
        ],
        [
          'Setengah dari 40 adalah ...',
          '20',
          '21',
          '22',
          '19'
        ],
        [
          'Setengah dari 44 adalah ...',
          '22',
          '23',
          '24',
          '21'
        ],
        [
          'Setengah dari 48 adalah ...',
          '24',
          '25',
          '26',
          '23'
        ],
        [
          'Seperempat dari 52 adalah ...',
          '13',
          '14',
          '15',
          '12'
        ],
        [
          'Setengah dari 56 adalah ...',
          '28',
          '29',
          '30',
          '27'
        ],
        [
          'Setengah dari 60 adalah ...',
          '30',
          '31',
          '32',
          '29'
        ],
        [
          'Setengah dari 64 adalah ...',
          '32',
          '33',
          '34',
          '31'
        ],
        [
          'Seperempat dari 68 adalah ...',
          '17',
          '18',
          '19',
          '16'
        ],
        [
          'Setengah dari 72 adalah ...',
          '36',
          '37',
          '38',
          '35'
        ],
        [
          'Setengah dari 76 adalah ...',
          '38',
          '39',
          '40',
          '37'
        ],
        [
          'Setengah dari 80 adalah ...',
          '40',
          '41',
          '42',
          '39'
        ],
        [
          'Seperempat dari 84 adalah ...',
          '21',
          '22',
          '23',
          '20'
        ],
        [
          'Setengah dari 88 adalah ...',
          '44',
          '45',
          '46',
          '43'
        ],
        [
          'Setengah dari 92 adalah ...',
          '46',
          '47',
          '48',
          '45'
        ],
        [
          'Setengah dari 96 adalah ...',
          '48',
          '49',
          '50',
          '47'
        ],
        [
          'Seperempat dari 100 adalah ...',
          '25',
          '26',
          '27',
          '24'
        ],
      ];

    // ========================================================
    // KELAS 6 - MATEMATIKA
    // ========================================================

    case 6:
      return const [
        [
          '20% dari 55 adalah ...',
          '11',
          '12',
          '13',
          '10'
        ],
        [
          '22 × 5 - 4 = ...',
          '106',
          '107',
          '108',
          '105'
        ],
        [
          'Setengah dari 48 ditambah 5 = ...',
          '29',
          '30',
          '31',
          '28'
        ],
        [
          '14 + (6 × 3) = ...',
          '32',
          '33',
          '34',
          '31'
        ],
        [
          '10% dari 75 adalah ...',
          '7.5',
          '8',
          '9',
          '6.5'
        ],
        [
          '26 × 3 - 4 = ...',
          '74',
          '75',
          '76',
          '73'
        ],
        [
          'Setengah dari 64 ditambah 5 = ...',
          '37',
          '38',
          '39',
          '36'
        ],
        [
          '18 + (5 × 3) = ...',
          '33',
          '34',
          '35',
          '32'
        ],
        [
          '50% dari 96 adalah ...',
          '48',
          '49',
          '47',
          '46'
        ],
        [
          '30 × 7 - 4 = ...',
          '206',
          '207',
          '208',
          '205'
        ],
        [
          'Setengah dari 80 ditambah 5 = ...',
          '45',
          '46',
          '47',
          '44'
        ],
        [
          '22 + (4 × 3) = ...',
          '34',
          '35',
          '36',
          '33'
        ],
        [
          '40% dari 115 adalah ...',
          '46',
          '47',
          '48',
          '45'
        ],
        [
          '34 × 5 - 4 = ...',
          '166',
          '167',
          '168',
          '165'
        ],
        [
          'Setengah dari 96 ditambah 5 = ...',
          '53',
          '54',
          '55',
          '52'
        ],
        [
          '26 + (3 × 3) = ...',
          '35',
          '36',
          '37',
          '34'
        ],
        [
          '30% dari 135 adalah ...',
          '40.5',
          '41',
          '42',
          '39'
        ],
        [
          '38 × 3 - 4 = ...',
          '110',
          '111',
          '112',
          '109'
        ],
        [
          'Setengah dari 112 ditambah 5 = ...',
          '61',
          '62',
          '63',
          '60'
        ],
        [
          '30 + (2 × 3) = ...',
          '36',
          '37',
          '38',
          '35'
        ],
      ];

    default:
      return const [];
  }
}

/// ============================================================
/// BAHASA INDONESIA
/// ============================================================

Question _languageQuestion(int grade, int index) {
  final item = _languageData(grade)[index];

  return _makeQuestion(
    id: 'k$grade-b$index',
    subject: 'Bahasa Indonesia',
    question: item[0],
    correct: item[1],
    wrong: [
      item[2],
      item[3],
      item[4],
    ],
    explanation: 'Jawaban yang tepat adalah "${item[1]}".',
    visual: '📚',
    isAnimated: index == 3 || index == 8,
  );
}

List<List<String>> _languageData(int grade) {
  switch (grade) {
    // ========================================================
    // KELAS 1
    // ========================================================

    case 1:
      return const [
        [
          'Huruf pertama pada kata "Ibu" adalah ...',
          'I',
          'B',
          'U',
          'A'
        ],
        [
          'Contoh huruf vokal adalah ...',
          'A',
          'B',
          'C',
          'D'
        ],
        [
          'Kata "Bola" terdiri dari ... suku kata.',
          '2',
          '1',
          '3',
          '4'
        ],
        [
          'Kata yang menunjukkan warna adalah ...',
          'merah',
          'lari',
          'duduk',
          'makan'
        ],
        [
          'Huruf terakhir pada kata "Kucing" adalah ...',
          'g',
          'n',
          'i',
          'u'
        ],
        [
          'Panggilan untuk orang tua laki-laki adalah ...',
          'Ayah',
          'Bunda',
          'Kakak',
          'Adik'
        ],
        [
          'Hewan yang berbunyi "meong" adalah ...',
          'kucing',
          'anjing',
          'ayam',
          'ikan'
        ],
        [
          'Lawan kata "besar" adalah ...',
          'kecil',
          'tinggi',
          'panjang',
          'banyak'
        ],
        [
          'Kalimat yang benar adalah ...',
          'Saya makan nasi.',
          'Nasi saya makan.',
          'Makan saya nasi.',
          'Saya nasi makan.'
        ],
        [
          'Jumlah huruf vokal dalam kata "Ibu" adalah ...',
          '2',
          '1',
          '3',
          '4'
        ],
      ];

    // ========================================================
    // KELAS 2
    // ========================================================

    case 2:
      return const [
        [
          'Lawan kata "besar" adalah ...',
          'kecil',
          'tinggi',
          'banyak',
          'jauh'
        ],
        [
          'Kata yang tepat: "Adik ... bola."',
          'menendang',
          'membaca',
          'menulis',
          'tidur'
        ],
        [
          'Kalimat tanya diakhiri tanda ...',
          '?',
          '.',
          '!',
          ','
        ],
        [
          'Kata dasar dari "bermain" adalah ...',
          'main',
          'ber',
          'main-main',
          'permainan'
        ],
        [
          'Sinonim dari "senang" adalah ...',
          'gembira',
          'sedih',
          'marah',
          'takut'
        ],
        [
          'Huruf kapital digunakan di ... kalimat.',
          'awal',
          'tengah',
          'akhir',
          'tidak digunakan'
        ],
        [
          'Kata "kami" digunakan untuk menyebut ...',
          'kita tanpa lawan bicara',
          'lawan bicara saja',
          'satu orang',
          'benda'
        ],
        [
          'Kalimat dengan huruf kapital yang benar adalah ...',
          'Budi pergi ke sekolah.',
          'budi pergi ke sekolah.',
          'Budi Pergi ke Sekolah.',
          'budi Pergi ke sekolah.'
        ],
        [
          'Tanda baca untuk kalimat berita adalah ...',
          '.',
          '?',
          '!',
          ','
        ],
        [
          'Tempat untuk belajar disebut ...',
          'sekolah',
          'pasar',
          'rumah sakit',
          'kebun'
        ],
      ];

    // ========================================================
    // KELAS 3
    // ========================================================

    case 3:
      return const [
        [
          'Sinonim dari "cepat" adalah ...',
          'lekas',
          'lambat',
          'diam',
          'berhenti'
        ],
        [
          'Antonim dari "terang" adalah ...',
          'gelap',
          'cerah',
          'indah',
          'panas'
        ],
        [
          'Kalimat perintah biasanya diakhiri tanda ...',
          '!',
          '.',
          '?',
          ','
        ],
        [
          'Imbuhan "ber-" pada kata "bermain" menunjukkan ...',
          'melakukan suatu kegiatan',
          'tempat',
          'jumlah',
          'waktu'
        ],
        [
          'Kata baku yang benar adalah ...',
          'apotek',
          'apotik',
          'apoteq',
          'apotiik'
        ],
        [
          'Ide pokok sebuah paragraf biasanya terdapat pada ...',
          'kalimat utama',
          'kalimat terakhir saja',
          'judul saja',
          'gambar'
        ],
        [
          'Kata ganti orang pertama adalah ...',
          'aku',
          'kamu',
          'dia',
          'mereka'
        ],
        [
          'Cerita yang berisi pesan moral biasanya disebut ...',
          'dongeng',
          'iklan',
          'surat',
          'resep'
        ],
        [
          'Huruf kapital digunakan untuk menulis ...',
          'nama orang',
          'kata kerja',
          'angka',
          'kata sifat'
        ],
        [
          'Kalimat yang menggunakan tanda baca dengan benar adalah ...',
          'Kapan kamu pulang?',
          'Kapan kamu pulang.',
          'kapan kamu pulang?',
          'Kapan Kamu Pulang'
        ],
      ];

    // ========================================================
    // KELAS 4
    // ========================================================

    case 4:
      return const [
        [
          'Kata hubung untuk kalimat majemuk setara adalah ...',
          'dan',
          'karena',
          'walaupun',
          'ketika'
        ],
        [
          'Imbuhan "me-kan" pada "membersihkan" bermakna ...',
          'melakukan sesuatu agar bersih',
          'menjadi bersih sendiri',
          'tempat bersih',
          'alat pembersih'
        ],
        [
          'Kalimat efektif adalah kalimat yang ...',
          'singkat dan jelas maknanya',
          'panjang dan berulang',
          'sulit dipahami',
          'menggunakan banyak kata'
        ],
        [
          'Sinonim dari "pintar" adalah ...',
          'cerdas',
          'bodoh',
          'malas',
          'lambat'
        ],
        [
          'Antonim dari "maju" adalah ...',
          'mundur',
          'cepat',
          'tinggi',
          'besar'
        ],
        [
          'Teks yang menjelaskan langkah-langkah disebut teks ...',
          'prosedur',
          'deskripsi',
          'narasi',
          'puisi'
        ],
        [
          'Kata tanya untuk menanyakan tempat adalah ...',
          'di mana',
          'kapan',
          'mengapa',
          'siapa'
        ],
        [
          'Paragraf yang ide pokoknya di awal disebut paragraf ...',
          'deduktif',
          'induktif',
          'campuran',
          'naratif'
        ],
        [
          'Kata ulang "anak-anak" menunjukkan makna ...',
          'jumlah banyak',
          'satu benda',
          'sifat benda',
          'waktu kejadian'
        ],
        [
          'Kalimat yang menggunakan huruf kapital dengan tepat adalah ...',
          'Dia tinggal di Kota Surabaya.',
          'dia tinggal di kota surabaya.',
          'Dia Tinggal di kota Surabaya.',
          'dia Tinggal Di Kota surabaya.'
        ],
      ];

    // ========================================================
    // KELAS 5
    // ========================================================

    case 5:
      return const [
        [
          'Peribahasa "Bagai air di daun talas" bermakna orang yang ...',
          'tidak berpendirian teguh',
          'rajin bekerja',
          'pandai berbicara',
          'suka menabung'
        ],
        [
          'Kalimat efektif dari "Rumah itu sangat besar sekali" adalah ...',
          'Rumah itu sangat besar.',
          'Rumah itu besar sekali sangat.',
          'Rumah sangat itu besar sekali.',
          'Besar itu rumah sangat sekali.'
        ],
        [
          'Majas yang membandingkan dua hal secara langsung disebut ...',
          'metafora',
          'personifikasi',
          'hiperbola',
          'ironi'
        ],
        [
          'Kata baku dari "nasehat" adalah ...',
          'nasihat',
          'nasehat',
          'naseehat',
          'nashat'
        ],
        [
          'Teks yang menceritakan pengalaman pribadi disebut teks ...',
          'narasi',
          'eksposisi',
          'argumentasi',
          'prosedur'
        ],
        [
          '"Hatinya membeku mendengar kabar itu" menggunakan majas ...',
          'metafora',
          'hiperbola',
          'ironi',
          'sarkasme'
        ],
        [
          'Sinonim dari "mustahil" adalah ...',
          'tidak mungkin',
          'sangat mungkin',
          'pasti terjadi',
          'sudah terjadi'
        ],
        [
          'Kata tanya untuk menanyakan alasan adalah ...',
          'mengapa',
          'kapan',
          'di mana',
          'siapa'
        ],
        [
          'Ringkasan cerita yang mempertahankan urutan asli disebut ...',
          'sinopsis',
          'parafrase',
          'kutipan',
          'dialog'
        ],
        [
          'Tanda titik dua digunakan sebelum ...',
          'rincian atau daftar',
          'nama orang',
          'judul buku',
          'angka saja'
        ],
      ];

    // ========================================================
    // KELAS 6
    // ========================================================

    case 6:
      return const [
        [
          'Majas hiperbola terdapat pada kalimat ...',
          'Suaranya menggelegar memecah langit.',
          'Dia berjalan pelan.',
          'Buku itu berwarna biru.',
          'Ibu memasak di dapur.'
        ],
        [
          'Kalimat yang menggunakan kata baku adalah ...',
          'Ia sedang menganalisis data.',
          'Ia sedang menganalisa data.',
          'Ia sedang menganalisis datah.',
          'Ia sedang menganalis data.'
        ],
        [
          'Ide pokok dalam sebuah teks biasanya terdapat pada ...',
          'kalimat utama',
          'kalimat penjelas',
          'judul saja',
          'gambar ilustrasi'
        ],
        [
          'Peribahasa "Tong kosong nyaring bunyinya" bermakna orang yang ...',
          'banyak bicara tetapi kurang berilmu',
          'pendiam dan bijaksana',
          'rajin bekerja',
          'jujur dan sederhana'
        ],
        [
          'Kata hubung antarkalimat yang menyatakan pertentangan adalah ...',
          'namun',
          'dan',
          'lalu',
          'kemudian'
        ],
        [
          'Teks yang bertujuan meyakinkan pembaca disebut teks ...',
          'persuasi',
          'deskripsi',
          'narasi',
          'laporan'
        ],
        [
          'Sinonim dari "bijaksana" adalah ...',
          'arif',
          'ceroboh',
          'malas',
          'sombong'
        ],
        [
          'Kalimat langsung ditandai dengan penggunaan tanda ...',
          'petik ("...")',
          'titik dua',
          'tanya saja',
          'seru saja'
        ],
        [
          'Unsur intrinsik cerita yang menunjukkan waktu dan tempat disebut ...',
          'latar',
          'tema',
          'amanat',
          'sudut pandang'
        ],
        [
          'Kata "walaupun" termasuk kata hubung ...',
          'pertentangan',
          'penjumlahan',
          'sebab akibat',
          'waktu'
        ],
      ];

    default:
      return const [];
  }
}

/// ============================================================
/// IPA
/// ============================================================

Question _scienceQuestion(int grade, int index) {
  final item = _scienceData(grade)[index];

  return _makeQuestion(
    id: 'k$grade-i$index',
    subject: 'IPA',
    question: item[0],
    correct: item[1],
    wrong: [
      item[2],
      item[3],
      item[4],
    ],
    explanation: 'Jawaban yang tepat adalah "${item[1]}".',
    visual: '🔬',
    isAnimated: index == 3 || index == 8,
  );
}

List<List<String>> _scienceData(int grade) {
  switch (grade) {
    // ========================================================
    // KELAS 1
    // ========================================================

    case 1:
      return const [
        [
          'Hewan berkaki empat adalah ...',
          'kucing',
          'burung',
          'ikan',
          'ayam'
        ],
        [
          'Bagian tubuh untuk melihat adalah ...',
          'mata',
          'telinga',
          'hidung',
          'mulut'
        ],
        [
          'Buah yang berwarna kuning adalah ...',
          'pisang',
          'semangka',
          'anggur',
          'apel'
        ],
        [
          'Air yang kita minum sebaiknya ...',
          'bersih',
          'kotor',
          'keruh',
          'berbau'
        ],
        [
          'Hewan yang bisa terbang adalah ...',
          'burung',
          'sapi',
          'kambing',
          'gajah'
        ],
        [
          'Bagian tubuh untuk mencium bau adalah ...',
          'hidung',
          'mata',
          'telinga',
          'kaki'
        ],
        [
          'Tanaman membutuhkan ... untuk tumbuh.',
          'air dan matahari',
          'pasir',
          'plastik',
          'asap'
        ],
        [
          'Hewan yang hidup di air adalah ...',
          'ikan',
          'ayam',
          'kucing',
          'kambing'
        ],
        [
          'Kita mandi menggunakan ...',
          'air dan sabun',
          'tanah',
          'minyak',
          'pasir'
        ],
        [
          'Sebelum makan sebaiknya kita ...',
          'cuci tangan',
          'bermain dulu',
          'tidur dulu',
          'lari-lari'
        ],
      ];

    // ========================================================
    // KELAS 2
    // ========================================================

    case 2:
      return const [
        [
          'Bagian tumbuhan yang berwarna hijau adalah ...',
          'daun',
          'akar',
          'bunga',
          'buah'
        ],
        [
          'Hewan yang termasuk unggas adalah ...',
          'ayam',
          'kucing',
          'sapi',
          'ikan'
        ],
        [
          'Makanan sehat untuk tubuh adalah ...',
          'sayur dan buah',
          'permen',
          'gorengan',
          'minuman soda'
        ],
        [
          'Kita bernapas menghirup ...',
          'oksigen',
          'karbon dioksida',
          'asap',
          'debu'
        ],
        [
          'Benda yang termasuk sumber cahaya adalah ...',
          'matahari',
          'batu',
          'kayu',
          'kertas'
        ],
        [
          'Hewan peliharaan yang suka menggonggong adalah ...',
          'anjing',
          'kucing',
          'burung',
          'ikan'
        ],
        [
          'Air akan membeku jika ...',
          'didinginkan',
          'dipanaskan',
          'dijemur',
          'diaduk'
        ],
        [
          'Bagian tubuh untuk berjalan adalah ...',
          'kaki',
          'tangan',
          'kepala',
          'perut'
        ],
        [
          'Sampah yang mudah membusuk disebut sampah ...',
          'organik',
          'plastik',
          'logam',
          'kaca'
        ],
        [
          'Olahraga membuat tubuh menjadi ...',
          'sehat dan kuat',
          'lemas',
          'sakit',
          'malas'
        ],
      ];

    // ========================================================
    // KELAS 3
    // ========================================================

    case 3:
      return const [
        [
          'Bagian tumbuhan yang menyerap air dari tanah adalah ...',
          'akar',
          'daun',
          'bunga',
          'buah'
        ],
        [
          'Hewan yang mengalami metamorfosis adalah ...',
          'kupu-kupu',
          'kucing',
          'ayam',
          'sapi'
        ],
        [
          'Proses tumbuhan membuat makanan disebut ...',
          'fotosintesis',
          'respirasi',
          'evaporasi',
          'pencernaan'
        ],
        [
          'Benda yang termasuk sumber energi panas adalah ...',
          'matahari',
          'air',
          'batu',
          'kayu'
        ],
        [
          'Hewan pemakan tumbuhan disebut ...',
          'herbivora',
          'karnivora',
          'omnivora',
          'insektivora'
        ],
        [
          'Air, tanah, dan udara termasuk ...',
          'sumber daya alam',
          'barang buatan',
          'hasil industri',
          'sampah'
        ],
        [
          'Rangka tubuh manusia berfungsi untuk ...',
          'menopang tubuh',
          'mencerna makanan',
          'melihat benda',
          'bernapas'
        ],
        [
          'Perubahan wujud dari cair menjadi gas disebut ...',
          'menguap',
          'membeku',
          'mencair',
          'mengembun'
        ],
        [
          'Contoh hewan karnivora adalah ...',
          'harimau',
          'sapi',
          'kambing',
          'kelinci'
        ],
        [
          'Cara menjaga lingkungan tetap bersih adalah ...',
          'membuang sampah pada tempatnya',
          'membakar sampah sembarangan',
          'membuang sampah ke sungai',
          'menumpuk sampah di jalan'
        ],
      ];

    // ========================================================
    // KELAS 4
    // ========================================================

    case 4:
      return const [
        [
          'Gaya yang menyebabkan benda jatuh ke bawah adalah gaya ...',
          'gravitasi',
          'gesek',
          'magnet',
          'otot'
        ],
        [
          'Alat yang menghasilkan bunyi karena getaran disebut ...',
          'sumber bunyi',
          'sumber cahaya',
          'sumber panas',
          'sumber listrik'
        ],
        [
          'Perpindahan panas tanpa zat perantara disebut ...',
          'radiasi',
          'konduksi',
          'konveksi',
          'isolasi'
        ],
        [
          'Rantai makanan diawali oleh ...',
          'produsen (tumbuhan)',
          'konsumen tingkat 1',
          'konsumen tingkat 2',
          'pengurai'
        ],
        [
          'Perubahan energi listrik menjadi cahaya terjadi pada ...',
          'lampu',
          'kipas angin',
          'setrika',
          'blender'
        ],
        [
          'Sumber energi yang tidak dapat diperbarui adalah ...',
          'minyak bumi',
          'air',
          'angin',
          'matahari'
        ],
        [
          'Daur hidup katak diawali dari ...',
          'telur',
          'kecebong',
          'katak muda',
          'katak dewasa'
        ],
        [
          'Alat pernapasan pada ikan adalah ...',
          'insang',
          'paru-paru',
          'kulit',
          'trakea'
        ],
        [
          'Gerhana matahari terjadi ketika ...',
          'bulan berada di antara matahari dan bumi',
          'bumi berada di antara matahari dan bulan',
          'matahari berada di antara bumi dan bulan',
          'bumi mengelilingi bulan'
        ],
        [
          'Magnet dapat menarik benda yang terbuat dari ...',
          'besi',
          'kayu',
          'plastik',
          'kertas'
        ],
      ];

    // ========================================================
    // KELAS 5
    // ========================================================

    case 5:
      return const [
        [
          'Organ pencernaan tempat penyerapan sari makanan adalah ...',
          'usus halus',
          'lambung',
          'usus besar',
          'kerongkongan'
        ],
        [
          'Planet terdekat dengan matahari adalah ...',
          'Merkurius',
          'Venus',
          'Bumi',
          'Mars'
        ],
        [
          'Peredaran darah yang melewati paru-paru disebut peredaran darah ...',
          'kecil',
          'besar',
          'ganda',
          'tunggal'
        ],
        [
          'Zat yang diperlukan tumbuhan untuk fotosintesis selain air adalah ...',
          'karbon dioksida',
          'oksigen murni',
          'nitrogen',
          'karbon monoksida'
        ],
        [
          'Alat pernapasan manusia yang menyaring udara adalah ...',
          'hidung',
          'paru-paru',
          'trakea',
          'diafragma'
        ],
        [
          'Gerhana bulan terjadi ketika ...',
          'bumi berada di antara matahari dan bulan',
          'bulan berada di antara matahari dan bumi',
          'matahari berada di antara bumi dan bulan',
          'bulan menjauhi bumi'
        ],
        [
          'Perubahan energi pada setrika listrik adalah ...',
          'listrik menjadi panas',
          'panas menjadi listrik',
          'cahaya menjadi panas',
          'gerak menjadi listrik'
        ],
        [
          'Hewan yang termasuk kelompok mamalia adalah ...',
          'paus',
          'hiu',
          'ubur-ubur',
          'gurita'
        ],
        [
          'Bagian jantung yang memompa darah ke seluruh tubuh adalah ...',
          'bilik kiri',
          'serambi kanan',
          'serambi kiri',
          'bilik kanan'
        ],
        [
          'Organ yang membantu mengatur suhu tubuh adalah ...',
          'kulit',
          'tulang',
          'otot',
          'rambut'
        ],
      ];

    // ========================================================
    // KELAS 6
    // ========================================================

    case 6:
      return const [
        [
          'Rangkaian listrik yang jika satu lampu mati semua lampu ikut mati disebut rangkaian ...',
          'seri',
          'paralel',
          'campuran',
          'terbuka'
        ],
        [
          'Planet yang dikenal sebagai planet merah adalah ...',
          'Mars',
          'Venus',
          'Jupiter',
          'Saturnus'
        ],
        [
          'Perkembangbiakan tumbuhan tanpa biji disebut ...',
          'vegetatif',
          'generatif',
          'fotosintesis',
          'respirasi'
        ],
        [
          'Contoh sumber energi alternatif adalah ...',
          'energi matahari',
          'batu bara',
          'minyak bumi',
          'gas alam'
        ],
        [
          'Bagian telinga yang menangkap gelombang bunyi adalah ...',
          'daun telinga',
          'gendang telinga',
          'koklea',
          'saraf pendengaran'
        ],
        [
          'Contoh pembiasan cahaya adalah ...',
          'pensil tampak patah di dalam air',
          'bayangan di cermin datar',
          'bayangan pada malam hari',
          'benda diam di udara'
        ],
        [
          'Ekosistem yang terbentuk secara alami disebut ekosistem ...',
          'alami',
          'buatan',
          'campuran',
          'tertutup'
        ],
        [
          'Salah satu ciri masa pubertas adalah ...',
          'tubuh mulai tumbuh lebih tinggi',
          'tubuh berhenti tumbuh',
          'tidak ada perubahan tubuh',
          'selalu merasa mengantuk'
        ],
        [
          'Gaya gesek dapat diperkecil dengan cara ...',
          'memberi pelumas atau oli',
          'memperkasar permukaan',
          'menambah beban',
          'memperlambat gerakan'
        ],
        [
          'Perubahan energi kimia menjadi energi listrik terjadi pada ...',
          'baterai',
          'kipas angin',
          'setrika',
          'lampu pijar'
        ],
      ];

    default:
      return const [];
  }
}

/// ============================================================
/// LOGIKA
/// ============================================================

Question _logicQuestion(int grade, int index) {
  final item = _logicData(grade)[index];

  return _makeQuestion(
    id: 'k$grade-l$index',
    subject: 'Logika',
    question: item[0],
    correct: item[1],
    wrong: [
      item[2],
      item[3],
      item[4],
    ],
    explanation: 'Perhatikan pola dan hubungan pada soal.',
    visual: '🧩',
    isAnimated: true,
  );
}

List<List<String>> _logicData(int grade) {
  switch (grade) {
    // ========================================================
    // KELAS 1
    // ========================================================

    case 1:
      return const [
        [
          '1, 2, 3, ...',
          '4',
          '5',
          '6',
          '2'
        ],
        [
          'Merah, biru, merah, biru, ...',
          'merah',
          'biru',
          'hijau',
          'kuning'
        ],
        [
          'Besar - kecil, tinggi - ...',
          'pendek',
          'panjang',
          'lebar',
          'berat'
        ],
        [
          'A, B, C, ...',
          'D',
          'E',
          'F',
          'C'
        ],
        [
          '1 bintang, 2 bintang, 3 bintang, ...',
          '4 bintang',
          '1 bintang',
          '2 bintang',
          '5 bintang'
        ],
        [
          'Siang terang, malam ...',
          'gelap',
          'dingin',
          'ramai',
          'basah'
        ],
        [
          '2, 4, 6, ...',
          '8',
          '7',
          '9',
          '10'
        ],
        [
          'Gajah lebih besar dari ...',
          'tikus',
          'singa',
          'paus',
          'jerapah'
        ],
        [
          'Urutan: kecil, sedang, ...',
          'besar',
          'kecil',
          'sedang',
          'sedikit'
        ],
        [
          'Matahari, bulan, matahari, bulan, ...',
          'matahari',
          'bulan',
          'bintang',
          'awan'
        ],
      ];

    // ========================================================
    // KELAS 2
    // ========================================================

    case 2:
      return const [
        [
          '5, 10, 15, ...',
          '20',
          '18',
          '25',
          '30'
        ],
        [
          'Pagi, siang, ...',
          'sore',
          'malam',
          'pagi',
          'subuh'
        ],
        [
          '1 segitiga, 2 segitiga, 3 segitiga, ...',
          '4 segitiga',
          '1 segitiga',
          '2 segitiga',
          '5 segitiga'
        ],
        [
          'Besar, sedang, ...',
          'kecil',
          'besar',
          'sedang',
          'banyak'
        ],
        [
          '2, 4, 6, 8, ...',
          '10',
          '9',
          '11',
          '12'
        ],
        [
          'Januari, Februari, ...',
          'Maret',
          'April',
          'Mei',
          'Desember'
        ],
        [
          'Jika hari ini Senin, besok adalah ...',
          'Selasa',
          'Rabu',
          'Minggu',
          'Kamis'
        ],
        [
          '10, 20, 30, ...',
          '40',
          '35',
          '45',
          '50'
        ],
        [
          'Panas berlawanan dengan ...',
          'dingin',
          'basah',
          'terang',
          'keras'
        ],
        [
          'Hijau, biru, hijau, biru, ...',
          'hijau',
          'biru',
          'merah',
          'kuning'
        ],
      ];

    // ========================================================
    // KELAS 3
    // ========================================================

    case 3:
      return const [
        [
          '3, 6, 9, ...',
          '12',
          '10',
          '11',
          '15'
        ],
        [
          'Dua merah, dua biru, dua merah, ...',
          'dua biru',
          'dua merah',
          'dua hijau',
          'dua kuning'
        ],
        [
          '1, 4, 9, 16, ...',
          '25',
          '20',
          '24',
          '36'
        ],
        [
          'Jika A=1 dan B=2, maka C=...',
          '3',
          '2',
          '4',
          '5'
        ],
        [
          '100, 90, 80, ...',
          '70',
          '75',
          '65',
          '60'
        ],
        [
          'Kupu-kupu berasal dari ...',
          'ulat',
          'telur burung',
          'ikan',
          'katak'
        ],
        [
          '2, 6, 18, ...',
          '54',
          '36',
          '44',
          '60'
        ],
        [
          'Segitiga, persegi, segilima, ...',
          'segienam',
          'segitiga',
          'lingkaran',
          'persegi'
        ],
        [
          '5, 10, 20, 40, ...',
          '80',
          '60',
          '70',
          '90'
        ],
        [
          'Senin, Rabu, Jumat, ...',
          'Minggu',
          'Sabtu',
          'Kamis',
          'Selasa'
        ],
      ];

    // ========================================================
    // KELAS 4
    // ========================================================

    case 4:
      return const [
        [
          '4, 8, 12, 16, ...',
          '20',
          '18',
          '22',
          '24'
        ],
        [
          '1, 1, 2, 3, 5, ...',
          '8',
          '6',
          '7',
          '9'
        ],
        [
          'Semua kucing adalah hewan. Milo adalah kucing. Jadi Milo adalah ...',
          'hewan',
          'tumbuhan',
          'benda',
          'manusia'
        ],
        [
          '2, 5, 10, 17, ...',
          '26',
          '24',
          '28',
          '30'
        ],
        [
          'Persegi memiliki ... sisi.',
          '4',
          '3',
          '5',
          '6'
        ],
        [
          '81, 27, 9, 3, ...',
          '1',
          '0',
          '2',
          '9'
        ],
        [
          'Jika hari ini tanggal 10, 5 hari lagi tanggal ...',
          '15',
          '14',
          '16',
          '20'
        ],
        [
          'Semua burung punya sayap. Elang adalah burung. Jadi elang punya ...',
          'sayap',
          'sirip',
          'insang',
          'kaki empat'
        ],
        [
          '3, 9, 27, ...',
          '81',
          '54',
          '72',
          '90'
        ],
        [
          'A1, B2, C3, ...',
          'D4',
          'E5',
          'D3',
          'C4'
        ],
      ];

    // ========================================================
    // KELAS 5
    // ========================================================

    case 5:
      return const [
        [
          '2, 6, 12, 20, ...',
          '30',
          '28',
          '26',
          '32'
        ],
        [
          'Semua siswa rajin belajar. Dodi adalah siswa. Jadi Dodi ...',
          'rajin belajar',
          'malas belajar',
          'tidak belajar',
          'bermain saja'
        ],
        [
          '1, 4, 9, 16, 25, ...',
          '36',
          '30',
          '32',
          '49'
        ],
        [
          'Jika kode A=2, B=4, C=6, maka D=...',
          '8',
          '6',
          '7',
          '10'
        ],
        [
          '5, 11, 23, 47, ...',
          '95',
          '90',
          '92',
          '100'
        ],
        [
          'Bangun datar bersisi 6 disebut ...',
          'segienam',
          'segilima',
          'segiempat',
          'segitujuh'
        ],
        [
          'Jika lusa adalah Jumat, maka hari ini adalah ...',
          'Rabu',
          'Kamis',
          'Sabtu',
          'Selasa'
        ],
        [
          '1000, 500, 250, ...',
          '125',
          '100',
          '150',
          '200'
        ],
        [
          'Semua ikan bernapas dengan insang. Lele adalah ikan. Jadi lele bernapas dengan ...',
          'insang',
          'paru-paru',
          'kulit',
          'trakea'
        ],
        [
          '2, 3, 5, 8, 13, ...',
          '21',
          '18',
          '20',
          '24'
        ],
      ];

    // ========================================================
    // KELAS 6
    // ========================================================

    case 6:
      return const [
        [
          '1, 2, 4, 8, 16, ...',
          '32',
          '24',
          '28',
          '36'
        ],
        [
          'Semua bilangan genap habis dibagi 2. 14 adalah bilangan genap. Jadi 14 ...',
          'habis dibagi 2',
          'tidak habis dibagi 2',
          'adalah bilangan ganjil',
          'tidak bisa dibagi'
        ],
        [
          '3, 8, 15, 24, ...',
          '35',
          '30',
          '32',
          '40'
        ],
        [
          'Jika kode BUKU = CVLV, maka kode MEJA = ...',
          'NFKB',
          'NFJB',
          'MFKB',
          'NFKC'
        ],
        [
          '2, 3, 5, 7, 11, ...',
          '13',
          '12',
          '14',
          '15'
        ],
        [
          '100, 81, 64, 49, ...',
          '36',
          '40',
          '42',
          '45'
        ],
        [
          'Jika semua A adalah B, dan semua B adalah C, maka semua A adalah ...',
          'C',
          'bukan C',
          'sebagian C',
          'tidak berhubungan dengan C'
        ],
        [
          '5, 10, 20, 40, 80, ...',
          '160',
          '120',
          '140',
          '150'
        ],
        [
          'Kode: 1=A, 2=B, 3=C, ... maka 8 = ...',
          'H',
          'G',
          'I',
          'F'
        ],
        [
          '7, 14, 28, 56, ...',
          '112',
          '84',
          '98',
          '120'
        ],
      ];

    default:
      return const [];
  }
}