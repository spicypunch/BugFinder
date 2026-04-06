import 'dart:io';

import 'package:bug_finder/l10n/app_localizations.dart';
import 'package:bug_finder/models/inspection_record.dart';
import 'package:bug_finder/repositories/inspection_history_repository.dart';
import 'package:bug_finder/screens/history_screen.dart';
import 'package:bug_finder/widgets/capture_result_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  testWidgets('capture preview sheet shows slider and close does not save', (
    WidgetTester tester,
  ) async {
    final FakeInspectionHistoryRepository repository =
        FakeInspectionHistoryRepository();

    await tester.pumpWidget(
      wrapWithApp(
        TickerMode(
          enabled: false,
          child: Scaffold(
            body: CaptureResultSheet(
              repository: repository,
              capturedAt: DateTime(2026, 4, 3, 9, 30),
              originalImagePath: '/missing/original.jpg',
              filteredImagePath: '/missing/filtered.jpg',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('촬영 결과'), findsOneWidget);
    expect(find.text('원본'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
    expect(find.text('메모'), findsOneWidget);
    expect(find.text('기록 저장'), findsOneWidget);
    expect(find.text('이미지를 찾을 수 없습니다'), findsWidgets);

    await tester.tap(find.text('닫기'));
    await tester.pump();

    expect(repository.saveCallCount, 0);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('history screen shows empty state', (
    WidgetTester tester,
  ) async {
    final FakeInspectionHistoryRepository emptyRepository =
        FakeInspectionHistoryRepository();

    await tester.pumpWidget(
      wrapWithApp(HistoryScreen(repository: emptyRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('저장된 검사 기록이 없습니다'), findsOneWidget);
  });

  testWidgets('history screen opens detail view for saved record', (
    WidgetTester tester,
  ) async {
    final FakeInspectionHistoryRepository repositoryWithRecord =
        FakeInspectionHistoryRepository(
      records: <InspectionRecord>[
        InspectionRecord(
          id: 'record-1',
          createdAt: DateTime(2026, 4, 3, 8, 15),
          originalImagePath: '/missing/original.jpg',
          filteredImagePath: '/missing/filtered.jpg',
          memo: '귀 뒤 다시 확인',
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithApp(HistoryScreen(repository: repositoryWithRecord)),
    );
    await tester.pumpAndSettle();

    expect(find.text('귀 뒤 다시 확인'), findsOneWidget);

    await tester.tap(find.byType(ListTile));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('기록 상세'), findsOneWidget);
    expect(find.text('귀 뒤 다시 확인'), findsWidgets);
    expect(find.text('원본'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
    expect(find.text('기록 삭제'), findsOneWidget);
  });
}

class FakeInspectionHistoryRepository extends InspectionHistoryRepository {
  FakeInspectionHistoryRepository({List<InspectionRecord>? records})
      : _records = records ?? <InspectionRecord>[],
        super(directoryProvider: _systemTempDirectoryProvider);

  List<InspectionRecord> _records;
  int saveCallCount = 0;

  static Future<Directory> _systemTempDirectoryProvider() async {
    return Directory.systemTemp;
  }

  @override
  Future<List<InspectionRecord>> loadRecords() async => _records;

  @override
  Future<InspectionRecord> saveRecord({
    required String originalImagePath,
    required String filteredImagePath,
    required String memo,
  }) async {
    saveCallCount += 1;
    final InspectionRecord record = InspectionRecord(
      id: 'saved-$saveCallCount',
      createdAt: DateTime(2026, 4, 3, 10, 0),
      originalImagePath: originalImagePath,
      filteredImagePath: filteredImagePath,
      memo: memo.trim(),
    );
    _records = <InspectionRecord>[record, ..._records];
    return record;
  }

  @override
  Future<void> deleteRecord(String id) async {
    _records =
        _records.where((InspectionRecord record) => record.id != id).toList();
  }
}
