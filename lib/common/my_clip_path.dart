import 'package:flutter/rendering.dart';

class MyClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height - 50);

    path.cubicTo((size.width / 4) * 2, size.height, size.width / 2,
        size.height / 2, 0, size.height - 50);

    path.lineTo(0, size.height - 50);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
