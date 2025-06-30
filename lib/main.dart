import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 앱 전역 카메라 리스트
List<CameraDescription> cameras = [];

// 네거티브 필터 적용 함수 (전역 함수)
Uint8List? applyNegativeFilter(Uint8List imageBytes) {
  try {
    // 이미지 디코딩
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      print('이미지 디코딩 실패');
      return null;
    }
    
    print('이미지 크기: ${originalImage.width}x${originalImage.height}');
    
    // 더 효율적인 방법으로 픽셀 처리
    final img.Image negativeImage = img.Image.from(originalImage);
    
    // 모든 픽셀에 대해 네거티브 효과 적용
    for (final pixel in negativeImage) {
      // RGB 값 반전 (255 - 원본값)
      pixel.r = 255 - pixel.r;
      pixel.g = 255 - pixel.g;
      pixel.b = 255 - pixel.b;
      // 알파값은 유지
    }
    
    // 이미지를 JPEG로 인코딩하여 반환
    final List<int> jpegBytes = img.encodeJpg(negativeImage, quality: 85);
    return Uint8List.fromList(jpegBytes);
    
  } catch (e) {
    print('네거티브 필터 적용 오류: $e');
    return null;
  }
}

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  // AdMob 초기화
  await MobileAds.instance.initialize();
  
  try {
    // 사용 가능한 카메라 목록 가져오기
    cameras = await availableCameras();
  } catch (e) {
    print('카메라 초기화 오류: $e');
  }
  
  runApp(const BugFinderApp());
}

class BugFinderApp extends StatelessWidget {
  const BugFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bug Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 다국어 지원 설정
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // 영어
        Locale('ko'), // 한국어
        Locale('zh'), // 중국어
        Locale('ja'), // 일본어
      ],
      home: const CameraScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  bool _isFlashOn = false;
  String? _lastCapturedImagePath;
  bool _isProcessingImage = false;
  bool _showHelpMessage = true;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _loadBannerAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // 배너 광고 로드 함수
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      // 실제 배포 시 아래 주석을 해제하고 테스트 ID 부분을 주석 처리하세요
      adUnitId: 'ca-app-pub-6140257895494497/2706309914', // 실제 배너 광고 ID
      
      // 테스트용 배너 광고 ID (개발/테스트 단계에서 사용)
      // adUnitId: Platform.isAndroid
      //     ? 'ca-app-pub-3940256099942544/6300978111' // Android 테스트 배너 ID
      //     : 'ca-app-pub-3940256099942544/2934735716', // iOS 테스트 배너 ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('배너 광고 로드 실패: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  // 카메라 초기화 함수
  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) {
      _showErrorDialog(AppLocalizations.of(context)!.cameraNotFound);
      return;
    }

    // 카메라 권한 확인
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isDenied) {
      _showErrorDialog(AppLocalizations.of(context)!.cameraPermissionRequired);
      return;
    }

    // 카메라 컨트롤러 초기화
    _cameraController = CameraController(
      cameras[_isRearCameraSelected ? 0 : 1],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog(AppLocalizations.of(context)!.cameraInitializationFailed(e.toString()));
    }
  }

  // 카메라 전환 함수
  Future<void> _switchCamera() async {
    if (cameras.length < 2) return;

    setState(() {
      _isCameraInitialized = false;
    });

    await _cameraController?.dispose();

    setState(() {
      _isRearCameraSelected = !_isRearCameraSelected;
    });

    await _initializeCamera();
  }

  // 플래시 토글 함수
  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('플래시 토글 오류: $e');
    }
  }

  // 사진 촬영 함수
  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessingImage) {
      return;
    }

    setState(() {
      _isProcessingImage = true;
    });
    
    // 처리 중 메시지 표시
    _showToast(AppLocalizations.of(context)!.processingImage);

    try {
      final XFile photo = await _cameraController!.takePicture();
      
      // 원본 이미지 파일 확인
      final File photoFile = File(photo.path);
      if (!await photoFile.exists()) {
        throw Exception('촬영된 이미지 파일을 찾을 수 없습니다');
      }
      
      // 원본 이미지 읽기
      final Uint8List originalImageBytes = await photoFile.readAsBytes();
      
      if (originalImageBytes.isEmpty) {
        throw Exception('이미지 데이터가 비어있습니다');
      }
      
      // 네거티브 필터 적용 (메인 스레드에서 처리 - 안정성 향상)
      final Uint8List? filteredImageBytes = applyNegativeFilter(originalImageBytes);
      
      if (filteredImageBytes == null) {
        // 필터 적용 실패 시 원본 이미지 저장
        await Gal.putImage(photo.path);
        setState(() {
          _lastCapturedImagePath = photo.path;
        });
        _showToast(AppLocalizations.of(context)!.fallbackImageSaved);
        return;
      }
      
      // 임시 파일에 필터링된 이미지 저장
      final String tempDir = photo.path.replaceAll(RegExp(r'\.(jpg|jpeg)$', caseSensitive: false), '_filtered.jpg');
      final File filteredFile = File(tempDir);
      await filteredFile.writeAsBytes(filteredImageBytes);
      
      // 갤러리에 필터링된 이미지 저장
      try {
        await Gal.putImage(filteredFile.path);
        if (mounted) {
          setState(() {
            _lastCapturedImagePath = filteredFile.path;
          });
          _showToast(AppLocalizations.of(context)!.imageSavedToGallery);
        }
        
        // 원본 및 임시 파일 정리
        try {
          await photoFile.delete();
        } catch (e) {
          print('원본 파일 삭제 오류: $e');
        }
      } on GalException catch (e) {
        if (mounted) {
          if (e.type == GalExceptionType.accessDenied) {
            _showToast(AppLocalizations.of(context)!.galleryAccessRequired);
          } else {
            _showToast(AppLocalizations.of(context)!.imageSaveFailed);
          }
        }
      }
    } catch (e) {
      print('촬영 오류 상세: $e');
      if (mounted) {
        _showToast(AppLocalizations.of(context)!.captureError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingImage = false;
        });
      }
    }
  }

  // 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.errorTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.confirmButton),
          ),
        ],
      ),
    );
  }

  // 토스트 메시지 표시
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 메인 카메라 영역
          Expanded(
            child: Stack(
              children: [
          // 카메라 미리보기 (전체 화면)
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -1, 0, 0, 0, 255,  // 빨간색 반전
                    0, -1, 0, 0, 255,  // 초록색 반전
                    0, 0, -1, 0, 255,  // 파란색 반전
                    0, 0, 0, 1, 0,     // 알파 값 유지
                  ]),
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // 상단 컨트롤 바
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 도움말 버튼 (플래시는 길게 눌러서)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showHelpMessage = true;
                      });
                    },
                    onLongPress: _toggleFlash,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Icon(
                            _showHelpMessage ? Icons.help : Icons.help_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          // 플래시 상태 표시 (작은 점)
                          if (_isFlashOn)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 앱 제목
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // 카메라 전환 버튼
                  IconButton(
                    onPressed: cameras.length > 1 ? _switchCamera : null,
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 컨트롤 바
          Positioned(
            bottom: _isBannerLoaded ? 100 : 50, // 배너가 있으면 더 위로
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 마지막 촬영 이미지 썸네일
                  if (_lastCapturedImagePath != null)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(_lastCapturedImagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 50),

                  // 촬영 버튼
                  GestureDetector(
                    onTap: _isProcessingImage ? null : _capturePhoto,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isProcessingImage ? Colors.grey : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 4,
                        ),
                      ),
                      child: _isProcessingImage
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.black,
                            ),
                    ),
                  ),

                  // 우측 공간
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),

          // 안내 메시지
          if (_showHelpMessage)
            Positioned(
              bottom: _isBannerLoaded ? 200 : 150, // 배너가 있으면 더 위로
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // 메시지 텍스트
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(
                        AppLocalizations.of(context)!.helpMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // X 닫기 버튼
                    Positioned(
                      top: -2,
                      right: -2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showHelpMessage = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            ),
          ),
          
          // 배너 광고 영역
          if (_isBannerLoaded && _bannerAd != null)
            Container(
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              color: Colors.black,
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}