# BugFinder Deployment Handoff

## Current state
- Local validation succeeded on this Mac.
- Android release bundle build succeeded: `flutter build appbundle --release`
- iOS release build succeeded without codesigning: `flutter build ios --release --no-codesign`
- Widget/unit tests succeeded: `flutter test`
- Android release APK passed 16 KB alignment verification.

## What changed in this branch
- Added inspection history flow:
  - post-capture result sheet
  - before/after slider
  - local inspection record storage
  - history list/detail screens
- Fixed Flutter localization generation usage by importing generated localizations from `lib/l10n/`
- Updated Android build chain for modern Play requirements:
  - AGP `8.11.1`
  - Gradle `8.14`
  - Kotlin `2.2.20`
  - Java/Kotlin target `17`
- Updated `intl` to `^0.20.2`
- Added minimal tests for image filter, inspection record serialization, repository persistence, and history UI
- Brought iOS project files up to date with current Flutter/Xcode project shape and iOS 13 minimum target

## Android release blockers
1. Upload keystore is missing on this machine.
   - `android/key.properties` does not exist.
   - Current release signing falls back to debug signing in `android/app/build.gradle`.
   - The locally built release APK is signed with `Android Debug`.
2. Real AdMob IDs are not configured.
   - Android App ID in `android/app/src/main/AndroidManifest.xml` is still the Google test ID.
   - Banner `adUnitId` in `lib/main.dart` is still empty.
3. Version must be checked against Play Console before upload.
   - Current app version is `3.0.0+3` in `pubspec.yaml`.
   - If Play already has build number `3` or higher, bump it before uploading.

## iOS release blockers
1. Signing is not fully configured in Xcode.
   - `PRODUCT_BUNDLE_IDENTIFIER` is currently `kr.jm.bugFinder`.
   - `DEVELOPMENT_TEAM` is not set in the project build settings.
   - App Store upload requires selecting the correct Apple team and provisioning profile in Xcode.
2. Real AdMob IDs are not configured.
   - `GADApplicationIdentifier` in `ios/Runner/Info.plist` is still the Google test ID.
3. App Store Connect metadata still needs to be filled from the Apple side.

## Deployment checklist

### Android
1. Recover the original upload keystore from the old Mac, or reset the upload key in Play Console if it is lost.
2. Create `android/key.properties` with the real keystore values.
3. Verify the package name matches the existing Play app:
   - `applicationId = "kr.jm.bug_finder"`
4. Replace AdMob test IDs with real production IDs, or temporarily remove ads for this release.
5. Bump `version` in `pubspec.yaml`.
6. Build:
   - `flutter build appbundle --release`
7. Confirm signing:
   - `apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk`
   - signer must not be `Android Debug`
8. Upload the AAB to Play Console.
9. Complete Play Console release metadata:
   - app description
   - screenshots
   - privacy policy URL
   - ads declaration
   - Data safety form

### iOS
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the correct Apple team under `Runner > Signing & Capabilities`.
3. Confirm the Bundle Identifier is the one intended for App Store Connect:
   - currently `kr.jm.bugFinder`
4. Replace AdMob test IDs with real production IDs, or temporarily remove ads for this release.
5. Bump `version` in `pubspec.yaml`.
6. Archive in Xcode or build through Flutter/Xcode after signing is fixed.
7. Upload to App Store Connect.
8. Complete App Store Connect metadata:
   - screenshots
   - app privacy answers
   - support URL
   - privacy policy URL
   - age rating questionnaire

## Commands that already worked here
```bash
/Users/mackim/fvm/default/bin/flutter test
/Users/mackim/fvm/default/bin/flutter build appbundle --release
/Users/mackim/fvm/default/bin/flutter build ios --release --no-codesign
```

## Notes
- `flutter analyze` still reports existing `avoid_print` info-level issues in `lib/main.dart`. They do not block release builds.
- Android 16 KB support is already in good shape on this branch. Local verification succeeded with:
```bash
$HOME/Library/Android/sdk/build-tools/36.1.0/zipalign -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk
```
