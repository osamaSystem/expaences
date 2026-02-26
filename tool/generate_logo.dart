import 'dart:io';

import 'package:image/image.dart' as img;

void main() async {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  final top = img.ColorRgb8(15, 23, 42);
  final bottom = img.ColorRgb8(8, 145, 178);

  for (var y = 0; y < size; y++) {
    final t = y / (size - 1);
    final r = (top.r + (bottom.r - top.r) * t).round();
    final g = (top.g + (bottom.g - top.g) * t).round();
    final b = (top.b + (bottom.b - top.b) * t).round();
    final rowColor = img.ColorRgb8(r, g, b);
    img.drawLine(image, x1: 0, y1: y, x2: size - 1, y2: y, color: rowColor);
  }

  img.fillCircle(
    image,
    x: 512,
    y: 370,
    radius: 260,
    color: img.ColorRgba8(255, 255, 255, 40),
  );

  final walletBody = img.ColorRgb8(245, 247, 250);
  final walletAccent = img.ColorRgb8(14, 116, 144);
  final walletShadow = img.ColorRgba8(0, 0, 0, 50);

  img.fillRect(image, x1: 250, y1: 350, x2: 790, y2: 760, color: walletShadow);
  img.fillRect(image, x1: 230, y1: 330, x2: 770, y2: 740, color: walletBody);
  img.fillRect(image, x1: 620, y1: 430, x2: 860, y2: 650, color: walletAccent);

  img.fillCircle(image,
      x: 690, y: 540, radius: 26, color: img.ColorRgb8(255, 255, 255));

  final chart1 = img.ColorRgb8(8, 145, 178);
  final chart2 = img.ColorRgb8(34, 197, 94);
  final chart3 = img.ColorRgb8(249, 115, 22);

  img.fillRect(image, x1: 310, y1: 590, x2: 380, y2: 700, color: chart1);
  img.fillRect(image, x1: 410, y1: 520, x2: 480, y2: 700, color: chart2);
  img.fillRect(image, x1: 510, y1: 460, x2: 580, y2: 700, color: chart3);

  final outputFile = File('assets/branding/expences_icon.png');
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsBytesSync(img.encodePng(image));

  stdout.writeln('Generated ${outputFile.path}');
}
