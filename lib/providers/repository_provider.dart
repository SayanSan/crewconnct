import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_repository.dart';
import 'auth_repository.dart';
import 'gig_repository.dart';
import 'application_repository.dart';
import 'notification_repository.dart';

// Configuration Provider
final useMockProvider = StateProvider<bool>((ref) => true);
final apiBaseUrlProvider = Provider<String>((ref) => 'http://localhost:8080');

// Auth Repository Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final useMock = ref.watch(useMockProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  
  if (useMock) {
    return MockAuthRepository();
  } else {
    return ApiAuthRepository(baseUrl: baseUrl);
  }
});

// Gig Repository Provider
final gigRepositoryProvider = Provider<IGigRepository>((ref) {
  final useMock = ref.watch(useMockProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  
  if (useMock) {
    return MockGigRepository();
  } else {
    return ApiGigRepository(baseUrl: baseUrl);
  }
});

// Application Repository Provider
final applicationRepositoryProvider = Provider<IApplicationRepository>((ref) {
  final useMock = ref.watch(useMockProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  
  if (useMock) {
    return MockApplicationRepository();
  } else {
    return ApiApplicationRepository(baseUrl: baseUrl);
  }
});

// Notification Repository Provider
final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  final useMock = ref.watch(useMockProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  
  if (useMock) {
    return MockNotificationRepository();
  } else {
    return ApiNotificationRepository(baseUrl: baseUrl);
  }
});
