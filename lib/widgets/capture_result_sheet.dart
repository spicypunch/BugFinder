import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/inspection_record.dart';
import '../repositories/inspection_history_repository.dart';
import 'before_after_slider.dart';

class CaptureResultSheet extends StatefulWidget {
  const CaptureResultSheet({
    super.key,
    required this.repository,
    required this.capturedAt,
    required this.originalImagePath,
    required this.filteredImagePath,
  });

  final InspectionHistoryRepository repository;
  final DateTime capturedAt;
  final String originalImagePath;
  final String filteredImagePath;

  @override
  State<CaptureResultSheet> createState() => _CaptureResultSheetState();
}

class _CaptureResultSheetState extends State<CaptureResultSheet> {
  late final TextEditingController _memoController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final InspectionRecord record = await widget.repository.saveRecord(
        originalImagePath: widget.originalImagePath,
        filteredImagePath: widget.filteredImagePath,
        memo: _memoController.text,
      );
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(record);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.historySaveFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String formattedDate = DateFormat.yMMMd(
      l10n.localeName,
    ).add_jm().format(widget.capturedAt);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.resultPreviewTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.capturedAtLabel}: $formattedDate',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              BeforeAfterSlider(
                originalImagePath: widget.originalImagePath,
                filteredImagePath: widget.filteredImagePath,
                height: 260,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _memoController,
                maxLength: 100,
                minLines: 1,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: l10n.memoLabel,
                  hintText: l10n.memoHint,
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context)
                              .maybePop<InspectionRecord?>(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.white30),
                      ),
                      child: Text(l10n.closeButton),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _saveRecord,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.saveToHistoryButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
