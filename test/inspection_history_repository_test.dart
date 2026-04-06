import 'dart:io';

import 'package:bug_finder/repositories/inspection_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  late Directory tempDirectory;
  late InspectionHistoryRepository repository;

  Future<String> createImageFile(String name, {int red = 20}) async {
    final img.Image image = img.Image(width: 2, height: 2);
    image.setPixelRgb(0, 0, red, 30, 40);
    image.setPixelRgb(1, 0, red, 30, 40);
    image.setPixelRgb(0, 1, red, 30, 40);
    image.setPixelRgb(1, 1, red, 30, 40);

    final File file = File('${tempDirectory.path}/$name.jpg');
    await file.writeAsBytes(img.encodeJpg(image));
    return file.path;
  }

  setUp(() async {
    tempDirectory =
        await Directory.systemTemp.createTemp('inspection_history_test');
    repository = InspectionHistoryRepository(
      directoryProvider: () async => tempDirectory,
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('saveRecord copies images and appends metadata', () async {
    final String originalPath = await createImageFile('original');
    final String filteredPath = await createImageFile('filtered', red: 200);

    final record = await repository.saveRecord(
      originalImagePath: originalPath,
      filteredImagePath: filteredPath,
      memo: '배 쪽 재확인',
    );

    final records = await repository.loadRecords();
    final File historyFile = File(
      '${tempDirectory.path}/inspection_history/history.json',
    );

    expect(records, hasLength(1));
    expect(records.first.id, record.id);
    expect(records.first.memo, '배 쪽 재확인');
    expect(File(record.originalImagePath).existsSync(), isTrue);
    expect(File(record.filteredImagePath).existsSync(), isTrue);
    expect(await historyFile.exists(), isTrue);
  });

  test('deleteRecord removes metadata and copied files', () async {
    final String originalPath = await createImageFile('original');
    final String filteredPath = await createImageFile('filtered', red: 220);

    final record = await repository.saveRecord(
      originalImagePath: originalPath,
      filteredImagePath: filteredPath,
      memo: '',
    );

    await repository.deleteRecord(record.id);

    final records = await repository.loadRecords();

    expect(records, isEmpty);
    expect(File(record.originalImagePath).existsSync(), isFalse);
    expect(File(record.filteredImagePath).existsSync(), isFalse);
  });

  test('loadRecords recovers from corrupted json', () async {
    final Directory historyDirectory = Directory(
      '${tempDirectory.path}/inspection_history',
    );
    await historyDirectory.create(recursive: true);
    final File historyFile = File('${historyDirectory.path}/history.json');
    await historyFile.writeAsString('{broken json');

    final records = await repository.loadRecords();

    expect(records, isEmpty);
    expect(await historyFile.readAsString(), '[]');
  });
}
