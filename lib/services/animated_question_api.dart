import 'package:dio/dio.dart';

/// Klien opsional untuk aset animasi soal dari API eksternal.
/// Tambahkan URL API melalui `--dart-define=QUESTION_ANIMATION_API_URL=https://...`.
/// Tanpa URL tersebut, kuis tetap memakai animasi lokal dan dapat berjalan offline.
class AnimatedQuestionApi {
  AnimatedQuestionApi() : _dio = Dio();

  final Dio _dio;
  static const _baseUrl = String.fromEnvironment('QUESTION_ANIMATION_API_URL');

  Future<Map<String, String>> loadVisuals(List<String> questionIds) async {
    if (_baseUrl.isEmpty || questionIds.isEmpty) return {};
    try {
      final response = await _dio.get<dynamic>(
        _baseUrl,
        queryParameters: {'questionIds': questionIds.join(',')},
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) return {};
      return data.map((id, url) => MapEntry(id, url.toString()));
    } on DioException {
      return {};
    }
  }
}
