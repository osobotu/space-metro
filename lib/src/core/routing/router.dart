import 'package:flutter/material.dart';
import 'package:space_metro/src/home/presentation/views/home_view.dart';
import 'package:space_metro/src/onboarding/presentation/views/onboarding_view.dart';

class MetroRouter {
  // ! Route Names
  // onboarding
  static const String onboarding = '/';

  // game page
  static const String game = '/game';

  // ! Router Function
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            // onboarding
            case onboarding:
              return const OnboardingView();
            case game:
              return const GamePage();
            default:
              return const OnboardingView();
          }
        });
  }
}
