# AURELIS native applications

This branch contains native implementations of AURELIS:

- `ios/AURELIS` — SwiftUI + SwiftData app for iOS 17+
- `android` — Kotlin + Jetpack Compose + Room app for Android

Both clients are offline-first and share the same domain model: income/expense entries and savings goals. The existing React/Vite app remains available on `main` as the design reference.

## iOS

Open `ios/AURELIS` in Xcode after creating an iOS App target named `AURELIS` (SwiftUI, Swift, iOS 17). Add the Swift files in this directory to the target and run.

## Android

Open the `android` directory in Android Studio, sync Gradle, and run the `app` configuration. Android Studio Hedgehog or newer is recommended.
