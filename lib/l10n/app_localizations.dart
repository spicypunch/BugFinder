import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Pet Tick Finder'**
  String get appTitle;

  /// Error message when camera is not available
  ///
  /// In en, this message translates to:
  /// **'Camera not found'**
  String get cameraNotFound;

  /// Error message when camera permission is denied
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required'**
  String get cameraPermissionRequired;

  /// Error message when camera initialization fails
  ///
  /// In en, this message translates to:
  /// **'Camera initialization failed: {error}'**
  String cameraInitializationFailed(String error);

  /// Error message when gallery access is denied
  ///
  /// In en, this message translates to:
  /// **'Gallery access permission is required'**
  String get galleryAccessRequired;

  /// Success message when image is saved
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// Error message when image save fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save image'**
  String get imageSaveFailed;

  /// Error message when photo capture fails
  ///
  /// In en, this message translates to:
  /// **'Photo capture error: {error}'**
  String captureError(String error);

  /// Title for error dialog
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirmButton;

  /// Help message shown to user
  ///
  /// In en, this message translates to:
  /// **'The negative filter is applied to make ticks, fleas, etc. more visible.\nCapture and save when you find suspicious areas.'**
  String get helpMessage;

  /// Message shown when processing captured image
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// Message when filter fails but original image is saved
  ///
  /// In en, this message translates to:
  /// **'Original image saved (filter failed)'**
  String get fallbackImageSaved;

  /// Tooltip for help button
  ///
  /// In en, this message translates to:
  /// **'Show Help'**
  String get showHelp;

  /// No description provided for @historyTooltip.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get historyTooltip;

  /// No description provided for @resultPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Capture result'**
  String get resultPreviewTitle;

  /// No description provided for @capturedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Captured'**
  String get capturedAtLabel;

  /// No description provided for @memoLabel.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memoLabel;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get memoHint;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @saveToHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get saveToHistoryButton;

  /// No description provided for @recordSaved.
  ///
  /// In en, this message translates to:
  /// **'Record saved'**
  String get recordSaved;

  /// No description provided for @historySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save record'**
  String get historySaveFailed;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved inspection records yet.'**
  String get historyEmpty;

  /// No description provided for @noMemoText.
  ///
  /// In en, this message translates to:
  /// **'No memo'**
  String get noMemoText;

  /// No description provided for @historyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Detail'**
  String get historyDetailTitle;

  /// No description provided for @deleteRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get deleteRecordButton;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// No description provided for @historyDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete record'**
  String get historyDeleteFailed;

  /// No description provided for @originalLabel.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalLabel;

  /// No description provided for @filteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Filtered'**
  String get filteredLabel;

  /// No description provided for @historyImageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get historyImageUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
