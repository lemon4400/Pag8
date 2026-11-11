# Hello World Flutter App (Android)

A minimal Flutter "Hello World" app structure for Android.

## Prerequisites

Install the Flutter SDK (Windows):

1. Download the Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Extract it (e.g. to `C:\src\flutter`) and add `C:\src\flutter\bin` to your PATH.
3. Install Android Studio (includes the Android SDK & emulator).
4. Run:
   ```powershell
   flutter doctor
   ```
   Fix any issues it reports (Android SDK licenses, etc.) via `flutter doctor --android-licenses`.

## Finish the project structure

The `android/` folder here is a skeleton. To generate the complete, working Android project (including the Gradle wrapper, resources, and `local.properties`), run inside this folder:

```powershell
flutter create .
```

This will regenerate `android/`, add `ios/`, `macos/`, etc., and create `local.properties` pointing at your Flutter SDK.

## Run the app

Connect an Android device (or start an emulator), then:

```powershell
flutter run
```

Or build a release APK:

```powershell
flutter build apk
```

## Project layout

```
hello_world_app/
├── pubspec.yaml          # Flutter project config & dependencies
├── lib/
│   └── main.dart         # App entry point (Hello World)
├── android/              # Android project skeleton
│   ├── build.gradle
│   ├── settings.gradle
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── java/com/example/hello_world_app/MainActivity.java
│   └── gradle/wrapper/gradle-wrapper.properties
├── .gitignore
└── README.md
```
