import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/gig_model.dart';
import '../models/application_model.dart';
import '../models/notification_model.dart';

/// Mock repository that provides sample data for running the app
/// without a live Firebase backend. Swap with real Firestore repos once configured.
class MockRepository {
  static final _uuid = const Uuid();

  // ── Mock Users ────────────────────────────────────────────────────────
  static final UserModel mockStudent = UserModel(
    id: 'student-001',
    email: 'alex@university.edu',
    phone: '+1234567890',
    name: 'Alex Johnson',
    userType: 'student',
    onboardingComplete: true,
    createdAt: DateTime(2025, 1, 15),
    updatedAt: DateTime(2025, 3, 1),
    skills: ['Flutter', 'React', 'Node.js', 'Photography', 'Event Setup'],
    bio: 'CS student passionate about tech events and creative gigs.',
    university: 'State University',
    resumeUrl: 'https://example.com/resume.pdf',
    availability: {'weekends': true, 'evenings': true},
  );

  static final UserModel mockManager = UserModel(
    id: 'manager-001',
    email: 'sarah@eventco.com',
    phone: '+0987654321',
    name: 'Sarah Mitchell',
    userType: 'manager',
    onboardingComplete: true,
    createdAt: DateTime(2024, 11, 1),
    updatedAt: DateTime(2025, 3, 1),
    organizationId: 'org-001',
    designation: 'Event Director',
  );

  // ── Mock Gigs ─────────────────────────────────────────────────────────
  static final List<GigModel> mockGigs = [
    GigModel(
      id: 'gig-001',
      title: 'Tech Conference Setup Crew',
      description:
          'Help us set up and manage a 500-person tech conference. Tasks include stage setup, AV equipment handling, registration desk management, and attendee coordination. Great opportunity to network with industry professionals.',
      location: 'Convention Center, Downtown',
      date: DateTime(2025, 4, 15),
      duration: '8 hours',
      pay: 150.0,
      requiredSkills: ['Event Setup', 'Communication'],
      managerId: 'manager-001',
      organizationId: 'org-001',
      organizationName: 'EventCo Productions',
      status: 'published',
      applicantCount: 12,
      createdAt: DateTime(2025, 3, 1),
      updatedAt: DateTime(2025, 3, 1),
    ),
    GigModel(
      id: 'gig-002',
      title: 'Photography for Corporate Gala',
      description:
          'Professional photography needed for an annual corporate gala dinner. Must have own camera equipment. Will cover candid shots, group photos, and event highlights. Images to be delivered within 48 hours.',
      location: 'Grand Hotel Ballroom',
      date: DateTime(2025, 4, 22),
      duration: '5 hours',
      pay: 250.0,
      requiredSkills: ['Photography', 'Photo Editing'],
      managerId: 'manager-001',
      organizationId: 'org-001',
      organizationName: 'EventCo Productions',
      status: 'published',
      applicantCount: 8,
      createdAt: DateTime(2025, 3, 2),
      updatedAt: DateTime(2025, 3, 2),
    ),
    GigModel(
      id: 'gig-003',
      title: 'Brand Ambassador — Product Launch',
      description:
          'Represent our tech brand at a major product launch event. Engage with attendees, distribute promotional materials, and collect leads. Training will be provided on the day.',
      location: 'Innovation Hub, Tech Park',
      date: DateTime(2025, 5, 1),
      duration: '6 hours',
      pay: 120.0,
      requiredSkills: ['Communication', 'Sales'],
      managerId: 'manager-001',
      organizationId: 'org-001',
      organizationName: 'EventCo Productions',
      status: 'published',
      applicantCount: 20,
      createdAt: DateTime(2025, 3, 3),
      updatedAt: DateTime(2025, 3, 3),
    ),
    GigModel(
      id: 'gig-004',
      title: 'Music Festival Volunteer Coordinator',
      description:
          'Lead a team of 15 volunteers during a two-day outdoor music festival. Responsibilities include shift scheduling, real-time problem solving, and volunteer welfare. Prior event management experience preferred.',
      location: 'Riverside Park',
      date: DateTime(2025, 5, 10),
      duration: '2 days',
      pay: 300.0,
      requiredSkills: ['Leadership', 'Event Management', 'Communication'],
      managerId: 'manager-001',
      organizationId: 'org-001',
      organizationName: 'EventCo Productions',
      status: 'published',
      applicantCount: 5,
      createdAt: DateTime(2025, 3, 4),
      updatedAt: DateTime(2025, 3, 4),
    ),
    GigModel(
      id: 'gig-005',
      title: 'Web Developer — Hackathon Support',
      description:
          'Provide on-site technical support during a 24-hour hackathon. Help participants debug code, set up dev environments, and troubleshoot APIs. Strong knowledge of web technologies required.',
      location: 'University Campus, Building C',
      date: DateTime(2025, 5, 20),
      duration: '12 hours',
      pay: 200.0,
      requiredSkills: ['Flutter', 'React', 'Node.js'],
      managerId: 'manager-001',
      organizationId: 'org-001',
      organizationName: 'EventCo Productions',
      status: 'draft',
      applicantCount: 0,
      createdAt: DateTime(2025, 3, 5),
      updatedAt: DateTime(2025, 3, 5),
    ),
  ];

  // ── Mock Applications ─────────────────────────────────────────────────
  static final List<ApplicationModel> mockApplications = [
    ApplicationModel(
      id: 'app-001',
      gigId: 'gig-001',
      gigTitle: 'Tech Conference Setup Crew',
      studentId: 'student-001',
      studentName: 'Alex Johnson',
      managerId: 'manager-001',
      status: 'shortlisted',
      coverNote: 'I have experience setting up events and am very reliable.',
      appliedAt: DateTime(2025, 3, 2),
      updatedAt: DateTime(2025, 3, 3),
    ),
    ApplicationModel(
      id: 'app-002',
      gigId: 'gig-002',
      gigTitle: 'Photography for Corporate Gala',
      studentId: 'student-001',
      studentName: 'Alex Johnson',
      managerId: 'manager-001',
      status: 'applied',
      coverNote: 'Photography is my passion. Portfolio available on request.',
      appliedAt: DateTime(2025, 3, 3),
      updatedAt: DateTime(2025, 3, 3),
    ),
  ];

  // ── Mock Notifications ────────────────────────────────────────────────
  static final List<NotificationModel> mockNotifications = [
    NotificationModel(
      id: 'notif-001',
      userId: 'student-001',
      title: 'Application Shortlisted! 🎉',
      body: 'Your application for "Tech Conference Setup Crew" has been shortlisted.',
      type: 'shortlisted',
      read: false,
      createdAt: DateTime(2025, 3, 3),
    ),
    NotificationModel(
      id: 'notif-002',
      userId: 'student-001',
      title: 'New Gig Near You',
      body: 'A new gig "Brand Ambassador — Product Launch" matches your skills.',
      type: 'new_gig',
      read: true,
      createdAt: DateTime(2025, 3, 3),
    ),
    NotificationModel(
      id: 'notif-003',
      userId: 'manager-001',
      title: 'New Application Received',
      body: 'Alex Johnson applied for "Tech Conference Setup Crew".',
      type: 'application_update',
      read: false,
      createdAt: DateTime(2025, 3, 2),
    ),
  ];

  // ── FAQ Data ──────────────────────────────────────────────────────────
  static final List<Map<String, String>> mockFaqs = [
    {
      'question': 'How do I apply for a gig?',
      'answer': 'Browse available gigs on the home screen, tap on one to view details, then tap "Quick Apply". You can optionally add a cover note.',
    },
    {
      'question': 'How does payment work?',
      'answer': 'Payment is handled directly between you and the event manager. The listed pay is per gig unless otherwise stated.',
    },
    {
      'question': 'Can I cancel my application?',
      'answer': 'Yes, you can withdraw your application from the "My Applications" screen as long as it hasn\'t been accepted yet.',
    },
    {
      'question': 'How do I update my skills?',
      'answer': 'Go to your Profile, tap "Skills", and add or remove skills. This helps us match you with relevant gigs.',
    },
    {
      'question': 'What happens after I\'m shortlisted?',
      'answer': 'The event manager will review your profile and may contact you directly. You\'ll receive a notification if you\'re accepted.',
    },
  ];
}
