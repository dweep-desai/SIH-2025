
# Smart Student Hub

Smart Student Hub is a cross-platform Flutter application designed to streamline student and faculty academic management. It features dashboards, profile management, achievements, approval workflows, and analytics for both students and faculty.

## Features

- Student and Faculty login
- Personalized dashboards for students and faculty
- Profile view and edit (with photo, domains, and more)
- Achievements and grades tracking
- Request Approval and Approval Status (with auto-accept and pending logic)
- Faculty analytics and student research tracking
- Firebase authentication and Firestore integration

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- Firebase project setup (see `firebase.json` and `lib/firebase_options.dart`)

### Installation
1. Clone this repository:
	```sh
	git clone <your-repo-url>
	cd SIH-2025
	```
2. Install dependencies:
	```sh
	flutter pub get
	```
3. Set up Firebase:
	- Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders if not present.
	- Update `lib/firebase_options.dart` if you change Firebase projects.
4. Run the app:
	```sh
	flutter run
	```

## Project Structure

- `lib/`
  - `main.dart` - App entry point
  - `pages/` - All main screens (dashboard, login, profile, etc.)
  - `widgets/` - Drawer, custom widgets
  - `data/` - Data models and providers
- `android/`, `ios/`, `web/`, `linux/`, `windows/`, `macos/` - Platform-specific code

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is for educational and hackathon use. See LICENSE if present.
