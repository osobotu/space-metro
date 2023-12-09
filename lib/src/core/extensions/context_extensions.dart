import 'package:flutter/material.dart';
import 'package:space_metro/src/core/constants/dimensions.dart';

extension ThemeDataX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  NavigatorState get navigator => Navigator.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // responsiveness
  bool get isMobile => mediaQuery.size.width < MetroDimensions.maxMobileWidth;
  bool get isTablet =>
      mediaQuery.size.width > MetroDimensions.maxMobileWidth &&
      mediaQuery.size.width < MetroDimensions.maxTabletWidth;
  bool get isDesktop => mediaQuery.size.width > MetroDimensions.maxTabletWidth;

  double scale(double value) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    double scaleFactor = width < height ? width : height;
    if (isMobile) {
      return (width * value) / MetroDimensions.maxMobileWidth;
    } else if (isTablet) {
      return (scaleFactor * value) / MetroDimensions.maxTabletWidth;
    } else {
      return (scaleFactor * value) / MetroDimensions.maxDesktopWidth;
    }
  }
}
