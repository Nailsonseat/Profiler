import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/profile.dart';

class ProfileApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
    ),
  );

  final _logger = Logger();

  Future<Profile> createProfile(Profile profile) async {
    try {
      final response = await _client.post('/api/profiles/', data: profile.toJson());
      return Profile.fromJson(response.data);
    } catch (e) {
      _logger.e('Error creating profile: $e');
      rethrow;
    }
  }
  
  Future<List<Profile>> getProfiles({int limit = 10, int offset = 0, String? query}) async {
    try {
      final response = await _client.get('/api/profiles/', queryParameters: {
        'q': query,
        'limit': limit,
        'offset': offset,
      });
      List<Profile> profiles = [];
      for (var profile in response.data['results']) {
        profiles.add(Profile.fromJson(profile as Map<String, dynamic>));
      }
      return profiles;
    } catch (e) {
      _logger.e('Error retrieving profiles: $e');
      rethrow;
    }
  }
  
  Future<Profile> getProfileById(int id) async {
    try {
      final response = await _client.get('/api/profiles/$id/');
      return Profile.fromJson(response.data);
    } catch (e) {
      _logger.e('Error retrieving profile with ID $id: $e');
      rethrow;
    }
  }
  
  Future<Profile> updateProfile(int id, Profile profile) async {
    try {
      final response = await _client.put('/api/profiles/$id/', data: profile.toJson());
      return Profile.fromJson(response.data);
    } catch (e) {
      _logger.e('Error updating profile with ID $id: $e');
      rethrow;
    }
  }
  
  Future<void> deleteProfile(int id) async {
    try {
      await _client.delete('/api/profiles/$id/');
    } catch (e) {
      _logger.e('Error deleting profile with ID $id: $e');
      rethrow;
    }
  }
}
