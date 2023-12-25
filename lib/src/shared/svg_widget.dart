import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGImmutableIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const SVGImmutableIcon(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.fit,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        assetName,
        fit: fit ?? BoxFit.contain,
      ),
    );
  }
}
