import 'package:bug_finder/models/inspection_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('InspectionRecord serializes and deserializes', () {
    final InspectionRecord record = InspectionRecord(
      id: 'record-1',
      createdAt: DateTime.parse('2026-04-03T12:34:56.000Z'),
      originalImagePath: '/tmp/original.jpg',
      filteredImagePath: '/tmp/filtered.jpg',
      memo: '귀 뒤를 다시 확인',
    );

    final Map<String, dynamic> json = record.toJson();
    final InspectionRecord restored = InspectionRecord.fromJson(json);

    expect(restored.id, record.id);
    expect(restored.createdAt, record.createdAt);
    expect(restored.originalImagePath, record.originalImagePath);
    expect(restored.filteredImagePath, record.filteredImagePath);
    expect(restored.memo, record.memo);
  });
}
