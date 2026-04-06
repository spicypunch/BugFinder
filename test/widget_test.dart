import 'dart:typed_data';

import 'package:bug_finder/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('applyNegativeFilter inverts pixel colors', () {
    final image = img.Image(width: 1, height: 1);
    image.setPixelRgb(0, 0, 10, 20, 30);

    final sourceBytes = Uint8List.fromList(img.encodeJpg(image));
    final filteredBytes = applyNegativeFilter(sourceBytes);

    expect(filteredBytes, isNotNull);

    final filteredImage = img.decodeJpg(filteredBytes!);
    expect(filteredImage, isNotNull);

    final pixel = filteredImage!.getPixel(0, 0);
    expect(pixel.r.toInt(), closeTo(245, 5));
    expect(pixel.g.toInt(), closeTo(235, 5));
    expect(pixel.b.toInt(), closeTo(225, 5));
  });
}
