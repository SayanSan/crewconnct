import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/application_model.dart';
import 'base_repository.dart';
import 'mock_repository.dart';

class MockApplicationRepository implements IApplicationRepository {
  @override
  Future<List<ApplicationModel>> fetchApplications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockRepository.mockApplications;
  }

  @override
  Future<bool> applyToGig({
    required String gigId,
    required String gigTitle,
    required String studentId,
    required String studentName,
    required String managerId,
    String? coverNote,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> updateApplicationStatus(String applicationId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

class ApiApplicationRepository implements IApplicationRepository {
  final String baseUrl;
  final String token;

  ApiApplicationRepository({required this.baseUrl, this.token = 'dev-token'});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<ApplicationModel>> fetchApplications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/applications'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List appsJson = json.decode(response.body);
      return appsJson.map((json) => ApplicationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch applications: ${response.statusCode}');
    }
  }

  @override
  Future<bool> applyToGig({
    required String gigId,
    required String gigTitle,
    required String studentId,
    required String studentName,
    required String managerId,
    String? coverNote,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/gigs/$gigId/apply'),
      headers: _headers,
      body: json.encode({
        'gigTitle': gigTitle,
        'studentName': studentName,
        'coverNote': coverNote,
      }),
    );
    return response.statusCode == 201;
  }

  @override
  Future<bool> updateApplicationStatus(String applicationId, String newStatus) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/applications/$applicationId'),
      headers: _headers,
      body: json.encode({'status': newStatus}),
    );
    return response.statusCode == 200;
  }
}
