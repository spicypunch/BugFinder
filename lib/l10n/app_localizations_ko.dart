// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '강아지 진드기 카메라';

  @override
  String get cameraNotFound => '카메라를 찾을 수 없습니다';

  @override
  String get cameraPermissionRequired => '카메라 권한이 필요합니다';

  @override
  String cameraInitializationFailed(String error) {
    return '카메라 초기화 실패: $error';
  }

  @override
  String get galleryAccessRequired => '갤러리 접근 권한이 필요합니다';

  @override
  String get imageSavedToGallery => '이미지가 갤러리에 저장되었습니다';

  @override
  String get imageSaveFailed => '이미지 저장에 실패했습니다';

  @override
  String captureError(String error) {
    return '사진 촬영 오류: $error';
  }

  @override
  String get errorTitle => '오류';

  @override
  String get confirmButton => '확인';

  @override
  String get helpMessage =>
      '네거티브 필터가 적용되어 진드기, 벼룩 등이 더 선명하게 보입니다.\n의심스러운 부분을 발견하면 촬영하여 저장하세요.';

  @override
  String get processingImage => '이미지 처리 중...';

  @override
  String get fallbackImageSaved => '원본 이미지가 저장되었습니다 (필터 적용 실패)';

  @override
  String get showHelp => '도움말 보기';

  @override
  String get historyTooltip => '기록 보기';

  @override
  String get resultPreviewTitle => '촬영 결과';

  @override
  String get capturedAtLabel => '촬영 시각';

  @override
  String get memoLabel => '메모';

  @override
  String get memoHint => '메모를 남겨보세요 (선택)';

  @override
  String get closeButton => '닫기';

  @override
  String get saveToHistoryButton => '기록 저장';

  @override
  String get recordSaved => '기록이 저장되었습니다';

  @override
  String get historySaveFailed => '기록 저장에 실패했습니다';

  @override
  String get historyTitle => '검사 기록';

  @override
  String get historyEmpty => '저장된 검사 기록이 없습니다';

  @override
  String get noMemoText => '메모 없음';

  @override
  String get historyDetailTitle => '기록 상세';

  @override
  String get deleteRecordButton => '기록 삭제';

  @override
  String get recordDeleted => '기록이 삭제되었습니다';

  @override
  String get historyDeleteFailed => '기록 삭제에 실패했습니다';

  @override
  String get originalLabel => '원본';

  @override
  String get filteredLabel => '필터';

  @override
  String get historyImageUnavailable => '이미지를 찾을 수 없습니다';
}
