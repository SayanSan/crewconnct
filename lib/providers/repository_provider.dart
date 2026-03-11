import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/base_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/firebase_auth_repository.dart';
import '../repositories/gig_repository.dart';
import '../repositories/application_repository.dart';
import '../repositories/notification_repository.dart';

// Configuration Provider
final useMockProvider = StateProvider<bool>((ref) => true);
final useFirebaseAuthProvider = StateProvider<bool>((ref) => false);
final apiBaseUrlProvider = Provider<String>((ref) => 'http://localhost:8080');

// Auth Repository Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final useMock = ref.watch(useMockProvider);
  final useFirebase = ref.watch(useFirebaseAuthProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  
  if (useFirebase) {
    return FirebaseAuthRepository();
  }
  
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
