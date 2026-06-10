// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pet Tick Finder';

  @override
  String get cameraNotFound => '找不到摄像头';

  @override
  String get cameraPermissionRequired => '需要摄像头权限';

  @override
  String cameraInitializationFailed(String error) {
    return '摄像头初始化失败: $error';
  }

  @override
  String get galleryAccessRequired => '需要相册访问权限';

  @override
  String get imageSavedToGallery => '图像已保存到相册';

  @override
  String get imageSaveFailed => '图像保存失败';

  @override
  String captureError(String error) {
    return '拍照错误: $error';
  }

  @override
  String get errorTitle => '错误';

  @override
  String get confirmButton => '确定';

  @override
  String get helpMessage => '负片滤镜已应用，可使蜱虫、跳蚤等更清晰可见。\n发现可疑区域时请拍摄并保存。';

  @override
  String get processingImage => '正在处理图像...';

  @override
  String get fallbackImageSaved => '已保存原始图像（滤镜应用失败）';

  @override
  String get showHelp => '显示帮助';

  @override
  String get historyTooltip => '查看记录';

  @override
  String get resultPreviewTitle => '拍摄结果';

  @override
  String get capturedAtLabel => '拍摄时间';

  @override
  String get memoLabel => '备注';

  @override
  String get memoHint => '添加备注（可选）';

  @override
  String get closeButton => '关闭';

  @override
  String get saveToHistoryButton => '保存记录';

  @override
  String get recordSaved => '记录已保存';

  @override
  String get historySaveFailed => '记录保存失败';

  @override
  String get historyTitle => '检查记录';

  @override
  String get historyEmpty => '还没有保存的检查记录';

  @override
  String get noMemoText => '无备注';

  @override
  String get historyDetailTitle => '记录详情';

  @override
  String get deleteRecordButton => '删除记录';

  @override
  String get recordDeleted => '记录已删除';

  @override
  String get historyDeleteFailed => '删除记录失败';

  @override
  String get originalLabel => '原图';

  @override
  String get filteredLabel => '滤镜';

  @override
  String get historyImageUnavailable => '找不到图像';
}
