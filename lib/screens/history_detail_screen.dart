import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/inspection_record.dart';
import '../repositories/inspection_history_repository.dart';
import '../widgets/before_after_slider.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({
    super.key,
    required this.repository,
    required this.record,
  });

  final InspectionHistoryRepository repository;
  final InspectionRecord record;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool _isDeleting = false;

  Future<void> _deleteRecord() async {
    if (_isDeleting) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await widget.repository.deleteRecord(widget.record.id);
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.historyDeleteFailed)),
      );
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String formattedDate = DateFormat.yMMMd(
      l10n.localeName,
    ).add_jm().format(widget.record.createdAt);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyDetailTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BeforeAfterSlider(
              originalImagePath: widget.record.originalImagePath,
              filteredImagePath: widget.record.filteredImagePath,
              height: 320,
            ),
            const SizedBox(height: 20),
            Text(
              '${l10n.capturedAtLabel}: $formattedDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.memoLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.record.memo.isEmpty
                    ? l10n.noMemoText
                    : widget.record.memo,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isDeleting ? null : _deleteRecord,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: _isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.delete_outline),
                label: Text(l10n.deleteRecordButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
