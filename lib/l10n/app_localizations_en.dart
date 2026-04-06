// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bug Finder';

  @override
  String get cameraNotFound => 'Camera not found';

  @override
  String get cameraPermissionRequired => 'Camera permission is required';

  @override
  String cameraInitializationFailed(String error) {
    return 'Camera initialization failed: $error';
  }

  @override
  String get galleryAccessRequired => 'Gallery access permission is required';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get imageSaveFailed => 'Failed to save image';

  @override
  String captureError(String error) {
    return 'Photo capture error: $error';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get confirmButton => 'OK';

  @override
  String get helpMessage =>
      'The negative filter is applied to make ticks, fleas, etc. more visible.\nCapture and save when you find suspicious areas.';

  @override
  String get processingImage => 'Processing image...';

  @override
  String get fallbackImageSaved => 'Original image saved (filter failed)';

  @override
  String get showHelp => 'Show Help';

  @override
  String get historyTooltip => 'View history';

  @override
  String get resultPreviewTitle => 'Capture result';

  @override
  String get capturedAtLabel => 'Captured';

  @override
  String get memoLabel => 'Memo';

  @override
  String get memoHint => 'Add a note (optional)';

  @override
  String get closeButton => 'Close';

  @override
  String get saveToHistoryButton => 'Save record';

  @override
  String get recordSaved => 'Record saved';

  @override
  String get historySaveFailed => 'Failed to save record';

  @override
  String get historyTitle => 'Inspection History';

  @override
  String get historyEmpty => 'No saved inspection records yet.';

  @override
  String get noMemoText => 'No memo';

  @override
  String get historyDetailTitle => 'Record Detail';

  @override
  String get deleteRecordButton => 'Delete record';

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get historyDeleteFailed => 'Failed to delete record';

  @override
  String get originalLabel => 'Original';

  @override
  String get filteredLabel => 'Filtered';

  @override
  String get historyImageUnavailable => 'Image not available';
}
