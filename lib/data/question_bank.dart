import '../models/question.dart';

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
