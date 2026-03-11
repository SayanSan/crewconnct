import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gig_model.dart';
import 'base_repository.dart';
import 'mock_repository.dart';

class MockGigRepository implements IGigRepository {
  @override
  Future<List<GigModel>> fetchGigs({String? status, String? skill}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var gigs = MockRepository.mockGigs;
    if (status != null) {
      gigs = gigs.where((g) => g.status == status).toList();
    }
    if (skill != null) {
      gigs = gigs.where((g) => g.requiredSkills.contains(skill)).toList();
    }
    return gigs;
  }

  @override
  Future<GigModel?> fetchGigById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockRepository.mockGigs.firstWhere((g) => g.id == id);
  }

  @override
  Future<bool> createGig(GigModel gig) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> updateGig(String id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> deleteGig(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

class ApiGigRepository implements IGigRepository {
  final String baseUrl;
  final String token;

  ApiGigRepository({required this.baseUrl, this.token = 'dev-token'});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<GigModel>> fetchGigs({String? status, String? skill}) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (skill != null) queryParams['skill'] = skill;

    final uri = Uri.parse('$baseUrl/api/gigs').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List gigsJson = data['gigs'];
      return gigsJson.map((json) => GigModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch gigs: ${response.statusCode}');
    }
  }

  @override
  Future<GigModel?> fetchGigById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/gigs/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return GigModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch gig: ${response.statusCode}');
    }
  }

  @override
  Future<bool> createGig(GigModel gig) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/gigs'),
      headers: _headers,
      body: json.encode(gig.toJson()),
    );
    return response.statusCode == 201;
  }

  @override
  Future<bool> updateGig(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/gigs/$id'),
      headers: _headers,
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> deleteGig(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/gigs/$id'),
      headers: _headers,
    );
    return response.statusCode == 200;
  }
}
