import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'base_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<void> checkAuthState() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      // In a real app, you'd fetch the full profile from Firestore here
      _currentUser = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber,
        name: firebaseUser.displayName ?? 'User',
        userType: 'student', // Default or fetch from Firestore
        onboardingComplete: true,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      _currentUser = null;
    }
  }

  @override
  Future<bool> register({required String email, required String password, required String userType}) async {
    // For Phone OTP flow, registration is implicitly handled by sign-in
    return true;
  }

  @override
  Future<void> sendOtp(String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await checkAuthState();
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<bool> verifyOtp(String otp, {String? verificationId}) async {
    if (verificationId == null) return false;
    
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      await checkAuthState();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> login({required String email, required String password, required String userType}) async {
    // login via phone is handled by sendOtp + verifyOtp
    return true;
  }
}
