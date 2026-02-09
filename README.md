
# COCO App - AI Guided Posting System

## Project Description

This is a university project developed by **Tosh Varma** and **Leonhard Richartz**. The project focuses on building an AI guided posting system that assists self employed users and small to medium sized enterprises in managing their social media content.

Many self employed professionals and SMEs lack the time and technical background required to plan posts, generate content, and maintain consistency across platforms. We address this problem by providing guided workflows and an AI chat client that supports content ideation, drafting, and post scheduling.

This repository contains both the Flutter mobile application and the Node.js backend used during development.

---

## Tools and Technologies

### Frontend

* Flutter
* Dart
* Android Studio

The frontend is a Flutter based mobile application developed and run using Android Studio.

### Backend

* Node.js
* Express.js
* Claude AI API (Anthropic)

---
## Cloning the Repository

To clone the project repository locally, run the following command:

```
git clone https://github.com/toshvarma/coco-app.git
```

Navigate into the project directory:
```
cd coco-app
```

---

## Running the Project Locally

### Backend Setup

1. Navigate to the backend directory:

```
cd coco-app/coco_backend
```

2. Install dependencies:

```
npm install
```

3. Create a `.env` file in `coco_backend` with the following contents:

```
PORT=3000
ANTHROPIC_API_KEY=your_api_key_here
```

4. Start the backend server in coco_backend:

```
npm start
```

### Frontend Setup

1. Open the project in Android Studio
2. Ensure Flutter and Dart are installed
3. Connect an Android device or start an emulator
4. Run the application:

```
flutter run
```

---

## API Base URL Configuration

The Flutter app switches API base URLs depending on the runtime environment. Example from `AuthService`:

```dart
class AuthService {
  // Android emulator
  // static const String _baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Browser or local testing
  // static const String _baseUrl = 'http://localhost:3000/api/auth';

  // Physical Android device
  static const String _baseUrl = 'http://192.168.0.100:3000/api/auth';
}
```

* `10.0.2.2` is used for Android emulators
* `localhost` is used for browser based testing
* A local IPv4 address is required when running on a physical Android device

---

## Screen Mirroring During Development

For development and presentations, the Android device screen was mirrored to a desktop machine using **scrcpy**:

[https://github.com/Genymobile/scrcpy](https://github.com/Genymobile/scrcpy)

---

## Contributors

* Tosh Varma
  (https://github.com/toshvarma)

* Leonhard Richartz
  (https://github.com/leonishard)

---


