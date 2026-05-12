# Global TNA App

`global_tna_app` is a Flutter demo task manager application.

It includes:

- A login screen with demo credentials
- A todo list built with `flutter_bloc`
- Add, complete, delete, and clear completed tasks


## What This App Does

The app starts on a login page and only allows access with the built-in demo account:

- Username: `admin`
- Password: `1234`

After login, the user can manage a personal todo list.

## Tech Stack

- Flutter
- Dart
- `flutter_bloc` / `bloc`
- `flutter_secure_storage`
- `google_fonts`

## Storage Behavior

This project does not currently use a backend API for todo data.

- On mobile/desktop, todos are stored locally using secure storage
- On web, todos are stored in browser cookies


## Prerequisites

Install the following before running the project:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code with Flutter extension
- A connected Android device, iOS simulator, Chrome, or another supported target

Check your environment with:

```powershell
flutter doctor
```

## Project Setup

1. Move into the project folder:

```powershell
cd C:\projects\Global-TNA\global_tna_app
```

2. Install dependencies:

```powershell
flutter pub get
```

3. Confirm available devices:

```powershell
flutter devices
```

## Run The App

Run on the default connected device:

```powershell
flutter run
```

Run on Chrome:

```powershell
flutter run -d chrome
```

Run on Android:

```powershell
flutter run -d android
```

If you have multiple devices connected, use the exact device id from `flutter devices`.

```

## Generate Code

This project includes `retrofit` and `build_runner` in dependencies. If generated files are added later, run:

```powershell
dart run build_runner build
```

If you need regeneration for conflicting outputs:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## Project Structure

```text
lib/
  bloc/       State management for auth and todos
  models/     Todo data model
  pages/      Login and todo UI screens
  storage/    Local persistence implementation
  main.dart   App entry point
```


