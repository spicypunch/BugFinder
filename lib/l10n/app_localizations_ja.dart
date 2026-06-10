// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pet Tick Finder';

  @override
  String get cameraNotFound => 'カメラが見つかりません';

  @override
  String get cameraPermissionRequired => 'カメラの権限が必要です';

  @override
  String cameraInitializationFailed(String error) {
    return 'カメラの初期化に失敗しました: $error';
  }

  @override
  String get galleryAccessRequired => 'ギャラリーへのアクセス権限が必要です';

  @override
  String get imageSavedToGallery => '画像がギャラリーに保存されました';

  @override
  String get imageSaveFailed => '画像の保存に失敗しました';

  @override
  String captureError(String error) {
    return '写真撮影エラー: $error';
  }

  @override
  String get errorTitle => 'エラー';

  @override
  String get confirmButton => 'OK';

  @override
  String get helpMessage =>
      'ネガティブフィルターが適用され、ダニやノミなどがより鮮明に見えます。\n疑わしい部分を発見したら撮影して保存してください。';

  @override
  String get processingImage => '画像を処理中...';

  @override
  String get fallbackImageSaved => '元の画像が保存されました（フィルタ適用失敗）';

  @override
  String get showHelp => 'ヘルプを表示';

  @override
  String get historyTooltip => '記録を見る';

  @override
  String get resultPreviewTitle => '撮影結果';

  @override
  String get capturedAtLabel => '撮影日時';

  @override
  String get memoLabel => 'メモ';

  @override
  String get memoHint => 'メモを残す（任意）';

  @override
  String get closeButton => '閉じる';

  @override
  String get saveToHistoryButton => '記録を保存';

  @override
  String get recordSaved => '記録を保存しました';

  @override
  String get historySaveFailed => '記録の保存に失敗しました';

  @override
  String get historyTitle => '検査記録';

  @override
  String get historyEmpty => '保存された検査記録はまだありません';

  @override
  String get noMemoText => 'メモなし';

  @override
  String get historyDetailTitle => '記録詳細';

  @override
  String get deleteRecordButton => '記録を削除';

  @override
  String get recordDeleted => '記録を削除しました';

  @override
  String get historyDeleteFailed => '記録の削除に失敗しました';

  @override
  String get originalLabel => '元画像';

  @override
  String get filteredLabel => 'フィルタ';

  @override
  String get historyImageUnavailable => '画像が見つかりません';
}
