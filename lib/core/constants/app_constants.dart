class AppConstants {
  AppConstants._();

  // ── App Info ───────────────────────────────────────────────────────────
  static const String appName = 'CrewConnct';
  static const String appTagline = 'Find Your Next Gig';

  // ── User Types ─────────────────────────────────────────────────────────
  static const String userTypeStudent = 'student';
  static const String userTypeManager = 'manager';

  // ── Gig Status ─────────────────────────────────────────────────────────
  static const String gigStatusDraft = 'draft';
  static const String gigStatusPublished = 'published';
  static const String gigStatusClosed = 'closed';

  // ── Application Status ─────────────────────────────────────────────────
  static const String applicationApplied = 'applied';
  static const String applicationShortlisted = 'shortlisted';
  static const String applicationAccepted = 'accepted';
  static const String applicationRejected = 'rejected';

  // ── Firestore Collections ──────────────────────────────────────────────
  static const String usersCollection = 'users';
  static const String gigsCollection = 'gigs';
  static const String applicationsCollection = 'applications';
  static const String organizationsCollection = 'organizations';
  static const String notificationsCollection = 'notifications';
  static const String faqsCollection = 'faqs';

  // ── Storage Paths ──────────────────────────────────────────────────────
  static const String profilePhotosPath = 'profile_photos';
  static const String resumesPath = 'resumes';
  static const String orgLogosPath = 'org_logos';

  // ── Pagination ─────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── OTP ────────────────────────────────────────────────────────────────
  static const int otpLength = 6;
  static const int otpTimeoutSeconds = 60;
}
