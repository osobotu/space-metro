import 'package:flutter/material.dart';
import 'package:space_metro/src/core/constants/dimensions.dart';

class MetroResponsiveWidget extends StatelessWidget {
  const MetroResponsiveWidget({
    super.key,
    required this.desktop,
    this.mobile,
    this.tablet,
  });

  final Widget? mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;

      if (maxWidth > MetroDimensions.maxTabletWidth) {
        return desktop;
      } else if (maxWidth > MetroDimensions.maxMobileWidth &&
          maxWidth <= MetroDimensions.maxTabletWidth) {
        return tablet ?? desktop;
      } else {
        return mobile ?? desktop;
      }
    });
  }
}
