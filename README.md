# Work Permit App (Flutter)

This is a mobile app for people who want to apply for a digital work permit.  
You can log in, get a code by email (2FA), check your application, and see your work permit.

---

## ✅ Features

- Login with username and password
- Two-step verification (2FA) with email code
- Dashboard to show visa status and notifications
- Timeline to track each step of the visa process
- Digital Work Permit screen
- Change language (English / Thai)
- Work offline and sync when online
- Auto logout after 30 minutes

---

## 📱 Screens

- **Login Screen**  
  Type your username and password.

- **Verification Screen**  
  Enter the code sent to your email.

- **Dashboard**  
  Shows your visa status and latest notifications.

- **Status Tracking**  
  Shows every step of the application process.

- **Language Button**  
  Change language anytime (EN / TH).

---

## 📦 How to Install

### 1. Get the code

```bash
git clone https://github.com/foxzilisk-dp/workpermit_sgn.git
cd workpermit_sgn
```

### 2. Install packages

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

You need Android 13+ or iOS 17.5+.

---

## 🌐 Languages
**The application supports**
- English
- Thai

---

## 📁 Data Files
These files are in the assets/ folder:
- users.json: mock users for login
- verification_code.json: code for 2FA
- dashboard/dashboard.json: visa status + notifications
- dashboard/status_tracking.json: timeline steps

---

## 🧪 Testing
To run all tests:

```bash
flutter test
```

---

## 🔧 Future Ideas
- Help and support screens
- Connect to real server
- Add push notifications
- Use state management 

---

## 👨‍💻 Developer
Made by Pichaya D.