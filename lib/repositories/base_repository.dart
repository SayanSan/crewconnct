import '../models/user_model.dart';
import '../models/gig_model.dart';
import '../models/application_model.dart';
import '../models/notification_model.dart';

abstract class IAuthRepository {
  Future<void> checkAuthState();
  Future<bool> register({required String email, required String password, required String userType});
  Future<void> sendOtp(String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onVerificationFailed,
  });
  Future<bool> verifyOtp(String otp, {String? verificationId});
  Future<bool> login({required String email, required String password, required String userType});
  UserModel? get currentUser;
}

abstract class IGigRepository {
  Future<List<GigModel>> fetchGigs({String? status, String? skill});
  Future<GigModel?> fetchGigById(String id);
  Future<bool> createGig(GigModel gig);
  Future<bool> updateGig(String id, Map<String, dynamic> data);
  Future<bool> deleteGig(String id);
}

abstract class IApplicationRepository {
  Future<List<ApplicationModel>> fetchApplications();
  Future<bool> applyToGig({
    required String gigId,
    required String gigTitle,
    required String studentId,
    required String studentName,
    required String managerId,
    String? coverNote,
  });
  Future<bool> updateApplicationStatus(String applicationId, String newStatus);
}

abstract class INotificationRepository {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> markAsRead(String notificationId);
}
