# CrewConnct 🚀

A gig staffing platform connecting **Students/Candidates** with **Event/Branch Managers**. Built with **Flutter** and **Google Cloud Platform**.

## Architecture

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x + Dart |
| State Management | Riverpod |
| Navigation | GoRouter with auth guards |
| Auth | Firebase Auth (OTP/Email) |
| Database | Cloud Firestore |
| File Storage | Cloud Storage |
| Push Notifications | Firebase Cloud Messaging |
| Backend API | Node.js + Express on Cloud Run |

## Getting Started

### Prerequisites
- Flutter SDK 3.2+
- Node.js 20+
- Firebase project (for production)

### Run Flutter App (Mock Mode)
```bash
cd crewconnct
flutter pub get
flutter run
```
The app runs with **mock data** by default — no Firebase config required.

### Run Backend (Development)
```bash
cd crewconnct/backend
npm install
NODE_ENV=development npm start
```

### Deploy Backend to Cloud Run
```bash
cd backend
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/crewconnct-api
gcloud run deploy crewconnct-api --image gcr.io/YOUR_PROJECT_ID/crewconnct-api --platform managed
```

## Project Structure
```
crewconnct/
├── lib/
│   ├── main.dart & app.dart          # Entry + MaterialApp
│   ├── core/                         # Theme, router, constants, widgets
│   ├── models/                       # Data models (User, Gig, Application, etc.)
│   ├── providers/                    # Riverpod state management
│   ├── repositories/                 # Data access (mock + Firebase)
│   └── features/                     # Feature screens
│       ├── auth/                     # Splash, Welcome, Register, Login, OTP
│       ├── onboarding/               # Student + Manager onboarding
│       ├── dashboard/                # Dashboards + bottom nav shell
│       ├── gigs/                     # Gig CRUD, list, detail
│       ├── applications/             # Apply, track, manage applicants
│       ├── profile/                  # View/edit profile, skills
│       ├── notifications/            # Notification feed
│       └── help/                     # Help center, FAQ, support chat
│
└── backend/
    ├── Dockerfile
    └── src/
        ├── index.js                  # Express server
        ├── middleware/auth.js        # Firebase token verification
        ├── routes/                   # API routes (gigs, apps, users, notifs)
        └── services/                 # Firestore + FCM helpers
```

## User Flows (from Figma Board)
1. **Auth**: Splash → Welcome → User Type → Register → OTP → Onboarding → Dashboard
2. **Student**: Browse gigs → View detail → Quick Apply → Track applications
3. **Manager**: Create gig → Preview → Publish → View applicants → Shortlist/Accept
4. **Profile**: Edit info, manage skills, upload resume, set availability
5. **Support**: Help center, FAQ, live support chat

## Connecting Firebase
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Auth, Firestore, Storage, and Cloud Messaging
3. Run `flutterfire configure` to generate `firebase_options.dart`
4. Uncomment the Firebase init line in `main.dart`
