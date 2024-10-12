import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/profile.dart';

class FunnyDescriptionApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
    ),
  );

  final _logger = Logger();

  Future<String> getFunnyDescription(Profile profile) async {
    try {
      final response = await _client.post('/api/description-generator/', data: profile.toJson());
      return response.data['output'];
    } catch (e) {
      _logger.e('Error creating profile: $e');
      return '';
    }
  }
}
