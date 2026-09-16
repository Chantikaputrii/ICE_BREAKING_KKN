import '../models/question.dart';

/// ============================================================
/// BANK SOAL
/// Semua kelas (1-6) memakai kumpulan soal yang sama:
/// 50 soal tema "Stop Bullying" (Soal Cerita, Dialog, Pilihan
/// Gabungan, dan Jebakan - tingkat lebih sulit).
///
/// Sumber: materi Sosialisasi Anti Bullying SDN 04 Begadung
/// - KKNT Universitas Negeri Surabaya.
///
/// Pretest:
/// - Hanya mengambil 10 soal
/// - Soal diacak berdasarkan nama siswa
/// - Urutan pilihan jawaban juga diacak
/// ============================================================

final Map<int, List<Question>> questionsByGrade = {
  for (var grade = 1; grade <= 6; grade++)
    grade: List<Question>.from(_stopBullyingQuestions),
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

  final matchedIndex = options.indexOf(correctAnswer);

  final safeAnswer = matchedIndex >= 0
      ? matchedIndex
      : question.answer.clamp(0, options.length - 1);

  return Question(
    id: question.id,
    subject: question.subject,
    question: question.question,
    options: options,
    answer: safeAnswer,
    explanation: question.explanation,
    visual: question.visual,
    isAnimated: question.isAnimated,
  );
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
/// SOAL TEMA STOP BULLYING (50 SOAL)
/// Sumber: materi Sosialisasi Anti Bullying SDN 04 Begadung
/// - KKNT Universitas Negeri Surabaya.
/// ============================================================

final List<Question> _stopBullyingQuestions = [
  _makeQuestion(
    id: 'sb-01',
    subject: 'Stop Bullying',
    question: 'Raka memanggil Beni dengan nama orang tuanya karena tahu Beni malu. Teman-teman tertawa, tetapi Beni meminta Raka berhenti. Kesimpulan paling tepat adalah ...',
    correct: 'Bullying verbal karena sengaja menyakiti dan tetap dilakukan',
    wrong: [
      'Bukan bullying karena teman-teman tertawa',
      'Bullying sosial karena terjadi di depan teman',
      'Bukan bullying jika pelaku menyebutnya bercanda',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-02',
    subject: 'Stop Bullying',
    question: 'Pilih SEMUA pasangan yang tepat!\n(1) Memukul teman → bullying fisik\n(2) Mengejek → bullying verbal\n(3) Sengaja mengucilkan → bullying sosial\n(4) Menghina lewat media sosial → cyberbullying',
    correct: '(1), (2), (3), dan (4)',
    wrong: [
      'Hanya (1) dan (2)',
      'Hanya (2) dan (3)',
      '(1), (2), dan (3)',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-03',
    subject: 'Stop Bullying',
    question: 'Dika tidak pernah menyentuh temannya. Ia setiap hari mengejek bentuk tubuh temannya sampai korban malu dan tidak percaya diri. Pernyataan yang paling tepat adalah ...',
    correct: 'Termasuk bullying verbal',
    wrong: [
      'Tidak termasuk bullying karena tidak ada sentuhan',
      'Termasuk bullying sosial saja',
      'Termasuk cyberbullying',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-04',
    subject: 'Stop Bullying',
    question: 'Pilih situasi yang PALING jelas menunjukkan bullying sosial.',
    correct: 'Sekelompok siswa sengaja tidak mengajak seorang teman bermain agar ia merasa sendirian',
    wrong: [
      'Siswa terpeleset lalu ditolong temannya',
      'Dua siswa berbeda pendapat saat berdiskusi',
      'Seorang siswa bercanda dengan julukan yang disukai temannya',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-05',
    subject: 'Stop Bullying',
    question: 'Seseorang mengirim hinaan dan ancaman melalui media sosial berkali-kali. Jika yang ditanyakan adalah MEDIA yang digunakan, jenisnya adalah ...',
    correct: 'Cyberbullying',
    wrong: [
      'Fisik',
      'Verbal langsung',
      'Sosial',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-06',
    subject: 'Stop Bullying',
    question: 'Andi berkata, “Aku tidak suka kamu memanggilku dengan julukan itu. Tolong berhenti.” Setelah itu ia meminta bantuan guru. Urutan sikap Andi menunjukkan ...',
    correct: 'Berani berkata tidak lalu mencari bantuan',
    wrong: [
      'Membalas pelaku lalu mengancamnya',
      'Mengucilkan pelaku lalu menyebarkannya',
      'Diam agar masalah cepat selesai',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-07',
    subject: 'Stop Bullying',
    question: 'Korban dipukul lalu memukul balik. Mengapa tindakan balasan tersebut kurang tepat menurut materi?',
    correct: 'Karena dapat memperbesar masalah',
    wrong: [
      'Karena korban harus selalu diam',
      'Karena pelaku selalu benar',
      'Karena bullying hanya boleh dilaporkan lewat media sosial',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-08',
    subject: 'Stop Bullying',
    question: 'Pilih tindakan yang paling aman ketika melihat teman dipukul.',
    correct: 'Segera melapor kepada guru atau orang dewasa',
    wrong: [
      'Ikut memukul pelaku',
      'Menonton sampai selesai',
      'Mengunggah videonya agar banyak orang tahu',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-09',
    subject: 'Stop Bullying',
    question: 'Mengucilkan dapat menjadi bullying sosial terutama karena ...',
    correct: 'menyakiti melalui hubungan/pergaulan sosial',
    wrong: [
      'selalu terjadi di internet',
      'selalu memakai kata-kata kasar',
      'harus disertai pukulan',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-10',
    subject: 'Stop Bullying',
    question: 'Perhatikan pasangan berikut: (1) memukul–fisik, (2) mengejek–verbal, (3) mengucilkan–sosial, (4) ancaman di media sosial–cyberbullying. Pilih jawaban yang benar.',
    correct: 'Semua pasangan benar',
    wrong: [
      '(1) dan (4) saja',
      '(1), (2), dan (3) saja',
      '(2) dan (4) saja',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-11',
    subject: 'Stop Bullying',
    question: 'JEBakan. Sinta memakai julukan yang memang disukai temannya dan temannya tidak merasa tersakiti. Kesimpulan paling hati-hati adalah ...',
    correct: 'Belum tentu bullying; perlu melihat unsur menyakiti, kesengajaan, dan pengulangan',
    wrong: [
      'Pasti bullying karena ada julukan',
      'Pasti bullying karena dilakukan di depan teman',
      'Pasti cyberbullying',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-12',
    subject: 'Stop Bullying',
    question: 'Awalnya sebuah ejekan dianggap bercanda. Setelah korban mengatakan sakit hati, pelaku tetap mengulanginya setiap hari. Unsur yang paling memperkuat bahwa tindakan itu merupakan bullying adalah ...',
    correct: 'Dilakukan sengaja, berulang, dan tetap menyakiti',
    wrong: [
      'Dilakukan di sekolah',
      'Ada penonton',
      'Teman-teman tertawa',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-13',
    subject: 'Stop Bullying',
    question: 'Pilih SEMUA dampak yang sesuai dengan materi.',
    correct: 'Semua benar',
    wrong: [
      'Malu',
      'Tidak percaya diri',
      'Trauma',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-14',
    subject: 'Stop Bullying',
    question: 'Seorang siswa sengaja tidak diajak bermain selama berhari-hari. Ia mulai merasa tidak diterima dan kehilangan percaya diri. Hubungan sebab-akibat yang paling tepat adalah ...',
    correct: 'Bullying sosial → dampak pada perasaan/kepercayaan diri',
    wrong: [
      'Cyberbullying → dampak fisik',
      'Bullying fisik → dampak sosial',
      'Candaan → pasti membuat percaya diri',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-15',
    subject: 'Stop Bullying',
    question: 'JEBakan. “Tidak ada pukulan, jadi tidak ada bullying.” Pernyataan ini ...',
    correct: 'Kurang tepat karena bullying juga dapat berupa verbal, sosial, dan cyberbullying',
    wrong: [
      'Benar',
      'Benar jika dilakukan di sekolah',
      'Benar jika korban tidak menangis',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-16',
    subject: 'Stop Bullying',
    question: 'Manakah pilihan yang paling mencerminkan “menjadi teman yang baik” sekaligus mencegah bullying?',
    correct: 'Menolong dan menyayangi teman tanpa mengejek atau mengucilkan',
    wrong: [
      'Memilih teman hanya dari kelompok sendiri',
      'Ikut mengejek agar dianggap kompak',
      'Diam ketika melihat teman disakiti',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-17',
    subject: 'Stop Bullying',
    question: 'Seorang anak duduk sendirian karena sengaja tidak diajak bermain. Pilih tindakan yang paling tepat.',
    correct: 'Mengajaknya bermain dan memperlakukannya dengan baik',
    wrong: [
      'Membiarkannya agar tidak ikut masalah',
      'Bertanya siapa yang salah lalu ikut mengejek',
      'Menjauh agar aman',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-18',
    subject: 'Stop Bullying',
    question: 'Pilih urutan tindakan yang paling sesuai ketika mengetahui cyberbullying: (1) tetap tenang, (2) membalas dengan hinaan, (3) melapor kepada orang dewasa, (4) menyebarkan tangkapan layar untuk mempermalukan pelaku.',
    correct: '1 dan 3',
    wrong: [
      '2 dan 4',
      '1, 2, dan 3',
      'Semua benar',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-19',
    subject: 'Stop Bullying',
    question: 'Mengapa membalas bullying dengan bullying bukan solusi?',
    correct: 'Karena dapat membuat masalah berlanjut dan menambah tindakan menyakiti',
    wrong: [
      'Karena korban tidak boleh bicara',
      'Karena pelaku harus dibiarkan',
      'Karena bullying hanya terjadi sekali',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-20',
    subject: 'Stop Bullying',
    question: 'Pilih kelompok tindakan yang seluruhnya sesuai dengan pesan “tak ada musuh, tak ada lawan, semua saling sayang dengan teman”.',
    correct: 'Menolong, menyayangi, tidak mengejek, melapor jika melihat bullying',
    wrong: [
      'Mengejek, mengucilkan, membalas',
      'Diam, membalas diam-diam, menghindar',
      'Membela teman dengan memukul pelaku',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-21',
    subject: 'Stop Bullying',
    question: 'DIALOG. Dodi: “Eh, si pendek!” Rian: “Aku tidak suka dipanggil begitu.” Dodi: “Cuma bercanda.” Jika Dodi mengulanginya terus, pilihan paling tepat adalah ...',
    correct: 'Bullying verbal',
    wrong: [
      'Bukan bullying karena Dodi menyebutnya bercanda',
      'Bullying sosial karena ada dialog',
      'Cyberbullying',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-22',
    subject: 'Stop Bullying',
    question: 'DIALOG. “Dasar bodoh! Kamu bikin kelompok kita kalah.” Ucapan sengaja diulang untuk merendahkan teman secara langsung. Ini termasuk ...',
    correct: 'Verbal',
    wrong: [
      'Fisik',
      'Sosial',
      'Cyberbullying',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-23',
    subject: 'Stop Bullying',
    question: 'DIALOG. “Nama ayahmu lucu. Mulai sekarang aku panggil kamu dengan nama ayahmu!” Korban tampak malu. Jika dilakukan untuk menyakiti dan berulang, jenis yang paling tepat adalah ...',
    correct: 'Verbal',
    wrong: [
      'Fisik',
      'Sosial',
      'Permainan biasa',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-24',
    subject: 'Stop Bullying',
    question: 'JEBakan. Pernyataan mana yang PALING tepat?',
    correct: 'Tidak semua candaan adalah bullying; konteks, kesengajaan, dampak, dan pengulangan perlu diperhatikan',
    wrong: [
      'Semua candaan adalah bullying',
      'Candaan pasti bukan bullying',
      'Jika teman tertawa, berarti tidak mungkin bullying',
    ],
    explanation: 'Perhatikan baik-baik: bullying dilihat dari unsur kesengajaan, pengulangan, dan rasa sakit yang dirasakan korban, bukan sekadar bentuk katanya.',
  ),
  _makeQuestion(
    id: 'sb-25',
    subject: 'Stop Bullying',
    question: 'Seorang siswa diejek dengan julukan setiap hari meskipun sudah mengatakan tidak suka. Manakah dua ciri yang paling jelas terlihat?',
    correct: 'Disengaja dan berulang',
    wrong: [
      'Lucu dan ramai',
      'Singkat dan spontan',
      'Tidak menyakiti dan disukai',
    ],
    explanation: 'Ini berkaitan dengan bullying verbal, yaitu menyakiti teman dengan kata-kata seperti ejekan atau julukan.',
  ),
  _makeQuestion(
    id: 'sb-26',
    subject: 'Stop Bullying',
    question: 'Korban mulai tidak percaya diri. Pilih tindakan teman yang paling tepat DAN paling lengkap.',
    correct: 'Memberi dukungan, mengajak bermain, dan membantu mencari orang dewasa',
    wrong: [
      'Menyuruh korban membalas',
      'Menjauhi korban agar tidak tertular masalah',
      'Menyebarkan cerita agar pelaku malu',
    ],
    explanation: 'Melapor kepada guru atau orang dewasa yang dipercaya adalah sikap paling aman saat melihat atau mengalami bullying.',
  ),
  _makeQuestion(
    id: 'sb-27',
    subject: 'Stop Bullying',
    question: 'Seorang siswa melihat temannya dipukul tetapi takut. Ia tidak aman untuk melerai secara fisik. Pilihan terbaik adalah ...',
    correct: 'Melapor kepada guru/orang dewasa',
    wrong: [
      'Membalas pelaku diam-diam',
      'Ikut tertawa agar tidak menjadi sasaran',
      'Mengunggah video',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-28',
    subject: 'Stop Bullying',
    question: 'JEBakan. “Semua korban bullying pasti mengalami dampak yang sama.” Penilaian yang paling tepat adalah ...',
    correct: 'Salah; dampak dapat berbeda, tetapi bullying dapat menyebabkan sakit hati, malu, tidak percaya diri, atau trauma',
    wrong: [
      'Benar',
      'Benar jika bullying dilakukan berulang',
      'Benar jika terjadi di sekolah',
    ],
    explanation: 'Perhatikan baik-baik: bullying dilihat dari unsur kesengajaan, pengulangan, dan rasa sakit yang dirasakan korban, bukan sekadar bentuk katanya.',
  ),
  _makeQuestion(
    id: 'sb-29',
    subject: 'Stop Bullying',
    question: 'Teman-teman tidak memukul dan tidak mengejek seorang siswa, tetapi sengaja tidak mau berbicara dan tidak mengajaknya bermain. Yang harus diperhatikan adalah ...',
    correct: 'Bisa merupakan bullying sosial',
    wrong: [
      'Pasti bullying fisik',
      'Pasti cyberbullying',
      'Semua tindakan diam pasti bullying',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-30',
    subject: 'Stop Bullying',
    question: 'Pelaku meminta maaf dan mulai mengubah perilakunya. Sikap yang sesuai semangat menjadi teman baik adalah ...',
    correct: 'Menghargai perubahan sambil tetap menjaga batas dan hubungan yang baik',
    wrong: [
      'Tetap membalas agar kapok',
      'Mengajak teman lain mengucilkannya',
      'Menyebarkan kesalahannya',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-31',
    subject: 'Stop Bullying',
    question: 'Pilih pernyataan yang BENAR.',
    correct: 'Bullying dapat berbentuk fisik, verbal, sosial, atau cyberbullying',
    wrong: [
      'Bullying hanya berupa pukulan',
      'Ejekan tidak pernah termasuk bullying',
      'Pengucilan tidak mungkin menyakiti',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-32',
    subject: 'Stop Bullying',
    question: 'Rina memaki Siska melalui media sosial hari ini dan mengulanginya besok. Jika diminta memilih alasan yang paling kuat menunjukkan unsur bullying, jawabannya adalah ...',
    correct: 'Diulang dan menyakiti teman',
    wrong: [
      'Menggunakan telepon',
      'Memiliki akun media sosial',
      'Dilakukan malam hari',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-33',
    subject: 'Stop Bullying',
    question: 'Pilih situasi yang termasuk bullying sosial.',
    correct: 'Sengaja membuat seorang teman tidak diterima dalam kelompok',
    wrong: [
      'Menendang kaki teman',
      'Menghina suara teman',
      'Mengirim ancaman melalui media sosial',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-34',
    subject: 'Stop Bullying',
    question: 'Pilih pernyataan yang membedakan bullying fisik dan verbal secara tepat.',
    correct: 'Fisik berkaitan dengan tindakan terhadap tubuh; verbal menggunakan perkataan',
    wrong: [
      'Fisik selalu di internet; verbal selalu di sekolah',
      'Fisik selalu bercanda; verbal selalu serius',
      'Fisik tidak menyakitkan; verbal pasti lebih menyakitkan',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-35',
    subject: 'Stop Bullying',
    question: 'JEBakan. Pernyataan yang paling tepat tentang cyberbullying dan bullying sosial adalah ...',
    correct: 'Cyberbullying menggunakan media digital; bullying sosial berkaitan dengan pengucilan/perlakuan dalam hubungan sosial',
    wrong: [
      'Cyberbullying selalu berupa pukulan',
      'Bullying sosial selalu menggunakan internet',
      'Keduanya hanya berupa kekerasan fisik',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-36',
    subject: 'Stop Bullying',
    question: 'Seorang siswa menerima ejekan melalui media sosial lalu merasa malu dan tidak percaya diri. Pilih hubungan yang tepat.',
    correct: 'Cyberbullying → dampak emosional',
    wrong: [
      'Bullying fisik → dampak emosional',
      'Bullying sosial → selalu cyberbullying',
      'Verbal langsung → fisik',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-37',
    subject: 'Stop Bullying',
    question: 'Seorang siswa melihat temannya dipukul dan ikut tertawa karena takut dianggap tidak kompak. Perubahan sikap yang paling tepat adalah ...',
    correct: 'Tetap tenang dan melaporkan kejadian',
    wrong: [
      'Ikut memukul',
      'Menyembunyikan kejadian',
      'Mengajak teman lain mengejek',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-38',
    subject: 'Stop Bullying',
    question: 'Keberanian berkata “tidak” penting karena ...',
    correct: 'Menunjukkan bahwa korban tidak menerima perlakuan yang menyakitkan',
    wrong: [
      'Membuat pelaku takut',
      'Memulai pertengkaran',
      'Membolehkan korban membalas',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-39',
    subject: 'Stop Bullying',
    question: 'Seorang siswa mengalami bullying sampai trauma. Pilih orang yang tepat untuk diberi tahu agar bantuan dapat diperoleh.',
    correct: 'Guru atau orang dewasa yang dapat membantu',
    wrong: [
      'Pelaku saja',
      'Tidak perlu siapa pun',
      'Hanya teman yang ikut melakukan bullying',
    ],
    explanation: 'Melapor kepada guru atau orang dewasa yang dipercaya adalah sikap paling aman saat melihat atau mengalami bullying.',
  ),
  _makeQuestion(
    id: 'sb-40',
    subject: 'Stop Bullying',
    question: 'Pilih kombinasi tindakan yang sesuai materi: (1) tetap tenang, (2) berani berkata tidak, (3) melapor kepada guru, (4) membalas dengan memukul.',
    correct: '1, 2, dan 3',
    wrong: [
      '1 dan 4',
      '2 dan 4',
      '1, 2, 3, dan 4',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-41',
    subject: 'Stop Bullying',
    question: 'JEBakan situasi. Teman mengajakmu mengucilkan seseorang agar kelompokmu dianggap kompak. Keputusan yang paling sesuai adalah ...',
    correct: 'Menolak dan tetap memperlakukan teman itu dengan baik',
    wrong: [
      'Ikut agar tidak dikucilkan',
      'Mengajak lebih banyak orang agar tekanan lebih kuat',
      'Mengejeknya agar kelompok tertawa',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-42',
    subject: 'Stop Bullying',
    question: 'Seorang siswa melihat teman tidak diajak bermain, lalu ia mengajak anak tersebut bergabung. Tindakan itu merupakan ...',
    correct: 'Melawan bullying dengan cara positif',
    wrong: [
      'Bullying sosial',
      'Bullying verbal',
      'Cyberbullying',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-43',
    subject: 'Stop Bullying',
    question: 'Pilih situasi yang menunjukkan DUA jenis bullying sekaligus.',
    correct: 'Mengejek teman lalu sengaja mengucilkannya dari kelompok',
    wrong: [
      'Memukul teman sekali',
      'Mengajak teman bermain',
      'Menolong teman yang jatuh',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-44',
    subject: 'Stop Bullying',
    question: 'JEBakan. Seseorang mengejek temannya secara langsung, lalu mengulang hinaan yang sama melalui media sosial. Jenis yang terlibat adalah ...',
    correct: 'Verbal dan cyberbullying',
    wrong: [
      'Hanya fisik',
      'Sosial dan fisik',
      'Hanya sosial',
    ],
    explanation: 'Ini berkaitan dengan cyberbullying, yaitu bullying yang dilakukan lewat internet atau media sosial.',
  ),
  _makeQuestion(
    id: 'sb-45',
    subject: 'Stop Bullying',
    question: 'Seorang anak dijauhi teman-temannya dan juga diberi julukan yang menyakitkan. Pilih pasangan jenis dan dampak yang paling sesuai.',
    correct: 'Sosial + verbal → dapat menyebabkan sakit hati dan tidak percaya diri',
    wrong: [
      'Fisik + cyberbullying → selalu membuat bangga',
      'Cyberbullying → pasti tidak berdampak',
      'Sosial → selalu membuat korban senang',
    ],
    explanation: 'Ini berkaitan dengan bullying sosial, yaitu menyakiti teman lewat hubungan pertemanan, misalnya dengan mengucilkan.',
  ),
  _makeQuestion(
    id: 'sb-46',
    subject: 'Stop Bullying',
    question: '“Saling menolong dan sayang dengan teman” paling jelas bertentangan dengan perilaku ...',
    correct: 'Bullying',
    wrong: [
      'Belajar',
      'Bermain',
      'Berdiskusi',
    ],
    explanation: 'Ingat untuk selalu bersikap saling menyayangi, tidak mengejek, tidak memukul, dan saling menolong dengan teman.',
  ),
  _makeQuestion(
    id: 'sb-47',
    subject: 'Stop Bullying',
    question: 'Jika siswa tidak mengejek, tidak memukul, saling menolong, dan menyayangi teman, lingkungan sekolah diharapkan menjadi ...',
    correct: 'Tempat yang lebih aman untuk berteman',
    wrong: [
      'Penuh persaingan dan permusuhan',
      'Tempat mencari musuh',
      'Tempat mengucilkan teman',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
  _makeQuestion(
    id: 'sb-48',
    subject: 'Stop Bullying',
    question: 'JEBakan. Seorang korban takut menghadapi bullying sendirian. Pilihan yang paling sesuai dengan materi adalah ...',
    correct: 'Melapor kepada guru atau orang dewasa yang dipercaya',
    wrong: [
      'Menyimpan semuanya sendiri',
      'Membalas diam-diam',
      'Menyebarkan masalah ke media sosial',
    ],
    explanation: 'Melapor kepada guru atau orang dewasa yang dipercaya adalah sikap paling aman saat melihat atau mengalami bullying.',
  ),
  _makeQuestion(
    id: 'sb-49',
    subject: 'Stop Bullying',
    question: 'Pilih kesimpulan yang PALING lengkap dari pernyataan “Bullying dapat membuat seseorang merasa sakit, malu, tidak percaya diri, dan trauma.”',
    correct: 'Bullying dapat memengaruhi kondisi perasaan korban sehingga perlu diperhatikan dan dilaporkan',
    wrong: [
      'Dampaknya hanya sesaat',
      'Bullying membuat korban semakin percaya diri',
      'Bullying tidak perlu dibicarakan',
    ],
    explanation: 'Melapor kepada guru atau orang dewasa yang dipercaya adalah sikap paling aman saat melihat atau mengalami bullying.',
  ),
  _makeQuestion(
    id: 'sb-50',
    subject: 'Stop Bullying',
    question: 'SOAL PILIHAN GABUNGAN. Manakah rangkaian yang seluruhnya mencerminkan prinsip “tak ada musuh, tak ada lawan, semua saling sayang dengan teman”?\n(1) Menolong teman\n(2) Tidak mengejek atau memukul\n(3) Melapor ketika melihat bullying\n(4) Membalas agar pelaku jera',
    correct: '(1), (2), dan (3)',
    wrong: [
      '(1) dan (2)',
      '(2), (3), dan (4)',
      'Semua benar',
    ],
    explanation: 'Ini berkaitan dengan bullying fisik, yaitu tindakan menyakiti tubuh teman secara sengaja dan berulang.',
  ),
];