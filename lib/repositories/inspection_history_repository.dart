import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/inspection_record.dart';

typedef AppDirectoryProvider = Future<Directory> Function();

class InspectionHistoryRepository {
  InspectionHistoryRepository({AppDirectoryProvider? directoryProvider})
      : _directoryProvider =
            directoryProvider ?? getApplicationDocumentsDirectory;

  final AppDirectoryProvider _directoryProvider;

  Future<List<InspectionRecord>> loadRecords() async {
    final File historyFile = await _historyFile();

    if (!await historyFile.exists()) {
      return <InspectionRecord>[];
    }

    try {
      final String contents = await historyFile.readAsString();
      if (contents.trim().isEmpty) {
        await _writeRecords(const <InspectionRecord>[]);
        return <InspectionRecord>[];
      }

      final dynamic decoded = jsonDecode(contents);
      if (decoded is! List) {
        await _writeRecords(const <InspectionRecord>[]);
        return <InspectionRecord>[];
      }

      final List<InspectionRecord> records = decoded
          .map<InspectionRecord>(
            (dynamic item) => InspectionRecord.fromJson(
                Map<String, dynamic>.from(item as Map)),
          )
          .toList()
        ..sort((InspectionRecord a, InspectionRecord b) {
          return b.createdAt.compareTo(a.createdAt);
        });

      return records;
    } catch (_) {
      await _writeRecords(const <InspectionRecord>[]);
      return <InspectionRecord>[];
    }
  }

  Future<InspectionRecord> saveRecord({
    required String originalImagePath,
    required String filteredImagePath,
    required String memo,
  }) async {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final DateTime createdAt = DateTime.now();
    final Directory imagesDirectory = await _imagesDirectory();
    await imagesDirectory.create(recursive: true);

    final String originalCopyPath = await _copyImageFile(
      sourcePath: originalImagePath,
      targetPath:
          '${imagesDirectory.path}/$id-original${_extensionFor(originalImagePath)}',
    );
    final String filteredCopyPath = await _copyImageFile(
      sourcePath: filteredImagePath,
      targetPath:
          '${imagesDirectory.path}/$id-filtered${_extensionFor(filteredImagePath)}',
    );

    final InspectionRecord record = InspectionRecord(
      id: id,
      createdAt: createdAt,
      originalImagePath: originalCopyPath,
      filteredImagePath: filteredCopyPath,
      memo: memo.trim(),
    );

    final List<InspectionRecord> records = await loadRecords();
    await _writeRecords(<InspectionRecord>[record, ...records]);
    return record;
  }

  Future<void> deleteRecord(String id) async {
    final List<InspectionRecord> records = await loadRecords();
    InspectionRecord? removedRecord;

    final List<InspectionRecord> updatedRecords = records.where((
      InspectionRecord record,
    ) {
      final bool shouldKeep = record.id != id;
      if (!shouldKeep) {
        removedRecord = record;
      }
      return shouldKeep;
    }).toList();

    if (removedRecord == null) {
      return;
    }

    await _writeRecords(updatedRecords);
    await _deleteFileIfExists(removedRecord!.originalImagePath);
    if (removedRecord!.filteredImagePath != removedRecord!.originalImagePath) {
      await _deleteFileIfExists(removedRecord!.filteredImagePath);
    }
  }

  Future<String> _copyImageFile({
    required String sourcePath,
    required String targetPath,
  }) async {
    final File sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Source image not found', sourcePath);
    }

    final File copiedFile = await sourceFile.copy(targetPath);
    return copiedFile.path;
  }

  Future<void> _deleteFileIfExists(String path) async {
    final File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _historyDirectory() async {
    final Directory appDirectory = await _directoryProvider();
    return Directory('${appDirectory.path}/inspection_history');
  }

  Future<Directory> _imagesDirectory() async {
    final Directory historyDirectory = await _historyDirectory();
    return Directory('${historyDirectory.path}/images');
  }

  Future<File> _historyFile() async {
    final Directory historyDirectory = await _historyDirectory();
    return File('${historyDirectory.path}/history.json');
  }

  Future<void> _writeRecords(List<InspectionRecord> records) async {
    final Directory historyDirectory = await _historyDirectory();
    await historyDirectory.create(recursive: true);

    final File historyFile = await _historyFile();
    final String contents = jsonEncode(
      records.map((InspectionRecord record) => record.toJson()).toList(),
    );
    await historyFile.writeAsString(contents);
  }

  String _extensionFor(String path) {
    final int lastDotIndex = path.lastIndexOf('.');
    if (lastDotIndex == -1) {
      return '.jpg';
    }

    final String extension = path.substring(lastDotIndex).toLowerCase();
    return extension.isEmpty ? '.jpg' : extension;
  }
}
