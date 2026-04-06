import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class BeforeAfterSlider extends StatefulWidget {
  const BeforeAfterSlider({
    super.key,
    required this.originalImagePath,
    required this.filteredImagePath,
    this.height = 280,
  });

  final String originalImagePath;
  final String filteredImagePath;
  final double height;

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _sliderPosition = 0.5;

  void _updateSliderPosition(Offset localPosition, double maxWidth) {
    if (maxWidth <= 0) {
      return;
    }

    setState(() {
      _sliderPosition = (localPosition.dx / maxWidth).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double sliderLeft = (constraints.maxWidth * _sliderPosition)
                .clamp(0.0, constraints.maxWidth);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (TapDownDetails details) {
                _updateSliderPosition(
                    details.localPosition, constraints.maxWidth);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                _updateSliderPosition(
                    details.localPosition, constraints.maxWidth);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ComparisonImage(path: widget.filteredImagePath),
                  ClipRect(
                    clipper: _RevealClipper(revealRatio: _sliderPosition),
                    child: _ComparisonImage(path: widget.originalImagePath),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _ImageLabel(text: l10n.originalLabel),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _ImageLabel(text: l10n.filteredLabel),
                  ),
                  Positioned(
                    left: sliderLeft - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 3, color: Colors.white),
                  ),
                  Positioned(
                    left: sliderLeft - 18,
                    top: (widget.height / 2) - 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.drag_indicator,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ComparisonImage extends StatelessWidget {
  const _ComparisonImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final File file = File(path);
    if (!file.existsSync()) {
      return const _MissingImagePlaceholder();
    }

    return Image.file(file, fit: BoxFit.cover);
  }
}

class _ImageLabel extends StatelessWidget {
  const _ImageLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MissingImagePlaceholder extends StatelessWidget {
  const _MissingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1B1B),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_not_supported_outlined,
              color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.historyImageUnavailable,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  const _RevealClipper({required this.revealRatio});

  final double revealRatio;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * revealRatio, size.height);
  }

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) {
    return oldClipper.revealRatio != revealRatio;
  }
}
