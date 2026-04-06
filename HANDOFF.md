# BugFinder Deployment Handoff

## Current state
- Local validation succeeded on this Mac.
- Android release bundle build succeeded: `flutter build appbundle --release`
- iOS release build succeeded without codesigning: `flutter build ios --release --no-codesign`
- Widget/unit tests succeeded: `flutter test`
- Android release APK passed 16 KB alignment verification.
- Shorebird initialization is done.
  - `shorebird.yaml` exists with app id `b4ac2834-5a1f-4d4f-a019-830f9288457e`
  - `pubspec.yaml` includes `shorebird.yaml` in Flutter assets

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
1. Version must be checked against Play Console before upload.
   - Current app version is `3.0.0+3` in `pubspec.yaml`.
   - If Play already has build number `3` or higher, bump it before uploading.
2. The ignored local signing file must exist on any release machine.
   - Local signing now expects `android/key.properties`.
   - That file is ignored by git and must be recreated on another machine.
3. Shorebird first release still needs to be created from this machine or another properly configured release machine.
   - `shorebird init` is already completed in the repo.
   - The first Shorebird release must be based on a real Android release build that is uploaded to Play.

## iOS release blockers
1. Signing is not fully configured in Xcode.
   - `PRODUCT_BUNDLE_IDENTIFIER` is currently `kr.jm.bugFinder`.
   - `DEVELOPMENT_TEAM` is not set in the project build settings.
   - App Store upload requires selecting the correct Apple team and provisioning profile in Xcode.
2. Real AdMob IDs are not configured.
   - Android AdMob is configured.
   - iOS `GADApplicationIdentifier` in `ios/Runner/Info.plist` is still the Google test ID.
3. App Store Connect metadata still needs to be filled from the Apple side.

## Deployment checklist

### Android
1. Verify the package name matches the existing Play app:
   - `applicationId = "kr.jm.bug_finder"`
2. Confirm `android/key.properties` exists locally with the correct keystore path and passwords.
3. Bump `version` in `pubspec.yaml`.
4. Build:
   - `flutter build appbundle --release`
5. Confirm signing:
   - `apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk`
   - signer must not be `Android Debug`
6. Upload the AAB to Play Console.
7. Complete Play Console release metadata:
   - app description
   - screenshots
   - privacy policy URL
   - ads declaration
   - Data safety form

### Shorebird for Android
1. Keep the Flutter release version aligned with the app build used for release.
   - Local project Flutter version is `3.41.2`
2. Run the first Shorebird release from a signed release machine:
   - `shorebird release android --artifact aab --flutter-version 3.41.2`
3. Upload the resulting Shorebird-backed AAB to Play Console for the matching store release.
4. Only after that release is live, use Shorebird patches for Dart-only updates:
   - `shorebird patch android --release-version 3.0.0+3`
5. If the Play build number changes before the first Shorebird release, update the patch target release version accordingly.

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
/Users/mackim/.shorebird/bin/shorebird doctor
/Users/mackim/.shorebird/bin/shorebird init --display-name "Bug Finder"
```

## Notes
- `flutter analyze` still reports existing `avoid_print` info-level issues in `lib/main.dart`. They do not block release builds.
- `shorebird doctor` warned that `pubspec.lock` and `ios/Podfile.lock` are not tracked in git. Shorebird can still be initialized, but tracking lockfiles is safer for reproducible releases.
- Android 16 KB support is already in good shape on this branch. Local verification succeeded with:
```bash
$HOME/Library/Android/sdk/build-tools/36.1.0/zipalign -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk
```
