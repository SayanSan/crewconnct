import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'base_repository.dart';
import 'mock_repository.dart';

class MockAuthRepository implements IAuthRepository {
  UserModel? _currentUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null; // Default to not logged in
  }

  @override
  Future<bool> register({required String email, required String password, required String userType}) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = userType == 'student' ? MockRepository.mockStudent : MockRepository.mockManager;
    return true;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return otp == '123456';
  }

  @override
  Future<bool> login({required String email, required String password, required String userType}) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = userType == 'student' ? MockRepository.mockStudent : MockRepository.mockManager;
    return true;
  }
}

class ApiAuthRepository implements IAuthRepository {
  final String baseUrl;
  UserModel? _currentUser;
  String? _token = 'dev-token';

  ApiAuthRepository({required this.baseUrl});

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<void> checkAuthState() async {
    // In dev mode, we can just fetch the 'me' profile with the dev token
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/me'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(json.decode(response.body));
      } else {
        _currentUser = null;
      }
    } catch (_) {
      _currentUser = null;
    }
  }

  @override
  Future<bool> register({required String email, required String password, required String userType}) async {
    // Mocking registration via API since we don't have a real registration endpoint in the Node.js layer (it uses Firebase)
    // But we can simulate the profile creation
    await Future.delayed(const Duration(seconds: 1));
    return true; 
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return otp == '123456';
  }

  @override
  Future<bool> login({required String email, required String password, required String userType}) async {
    // In dev mode, we just fetch a fixed user
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      _currentUser = UserModel.fromJson(json.decode(response.body));
      return true;
    }
    return false;
  }
}
