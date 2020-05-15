# Gentle Flutter App

This is the Flutter code for Gentle — likely the most interesting part of this project. This is a snapshot of the codebase at time of shutdown, meaning parts of it may be incomplete or out-of-date.

## Folder structure

Here's a list of relevant folders (I'm assuming you are already familiar with Flutter projects).

```
.
├── android                   # Android-specific build files
├── assets
│   ├── fonts                 # Folder for the `Inter` font files
│   └── images                # All icons, illustrations, etc.
├── ios                       # iOS-specific build files
│   └── config
│       └── dev               # Where to put your dev `GoogleService-Info.plist`
│       └── prod              # Where to put your prod `GoogleService-Info.plist`
└── lib
    ├── components            # All custom widgets
    ├── models                # Data models (uses `freezed` heavily)
    ├── providers             # `ChangeNotifier`s used for UI and business logic
    ├── routes                # Custom route transitions
    ├── screens               # App screens
    └── services              # `get_it` utility classes
```

## Setup

> Note: This code will run on iOS, but needs modifications to run on Android. I had a branch with a working Android build, but it was incomplete. Assume that this Flutter codebase has never been setup for Android development.

I am not providing specific support to get this running, but here are some basic things to do in order to setup the project:

1. Familiarize yourself with all the packages used in `pubspec.yaml` (for example, the use of [`freezed`](https://pub.dev/packages/freezed) for generated data model files).
2. Add Firebase `GoogleService-Info.plist` files to `ios/config/dev` (dev environment) and `ios/config/prod` (production environment).
3. Add the [Inter font files](https://rsms.me/inter/) specified in `pubspec.yaml`.
4. Add a Sentry DSN to `lib/services/error_reporter.dart`, or modify the code to not use Sentry.
5. Setup signing in the `ios/Runner.xcworkspace` project.

## Removed code

- Firebase config files
- Sentry config
- Various URL's

## Notes

- The last flutter version this codebase worked with is `0.15.17`.
- The state management system I chose was using the `provider` package with `ChangeNotifier`s.
- No testing code whatsoever. I didn't prioritize it for Gentle. 🤷‍♂️
