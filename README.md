Visa Work Permit App
This is a mobile app for people who want to apply for a digital work permit (LTR visa).
You can login, verify your email, and check your application status.

The app works in English and Thai. It also works offline and syncs when online.

✅ Features
Login with username and password
Verify with code sent by email (2FA)
Show application status
Show notifications
Switch language between English and Thai
Auto logout after 30 minutes
Offline mode supported

📦 Folder Structure
lib/
├── main.dart                  # App starts here
├── screens/                   # App pages
│   ├── login_screen.dart
│   ├── verification_screen.dart
│   ├── dashboard_screen.dart
│   └── status_tracking_screen.dart
├── services/                  # Logic for login, session, etc.
├── local_stores/              # Language and settings
└── assets/                    # Mock JSON data

🔧 How to Install
Clone the project

bash
Copy code
git clone https://github.com/your-org/workpermit-app.git
cd workpermit-app
Install Flutter packages

bash
Copy code
flutter pub get
Run the app

bash
Copy code
flutter run

🌐 Change Language
Tap the 🌍 language button in the bottom right

Choose English or ไทย

🧪 Run Tests
bash
Copy code
flutter test

📁 Mock Data
We use local JSON files instead of a real server:

File	Description
assets/users.json	Login usernames and passwords
assets/verification_code.json	Email code for 2FA
assets/dashboard/dashboard.json	Visa status + notifications
assets/dashboard/status_tracking.json	Steps of the visa process

📱 Requirements
Android 13+
iOS 17.5+ (for NFC)
Flutter 3.10+

👤 Author
Made by Pichaya Deachpol
This project is for demo