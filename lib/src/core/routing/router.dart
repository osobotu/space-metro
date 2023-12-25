import 'package:flutter/material.dart';
import 'package:space_metro/src/authentication/presentation/views/login_view.dart';
import 'package:space_metro/src/authentication/presentation/views/signup_view.dart';
import 'package:space_metro/src/home/presentation/views/home_view.dart';
import 'package:space_metro/src/leaderboard/presentation/views/leaderboard_view.dart';
import 'package:space_metro/src/onboarding/presentation/views/onboarding_view.dart';

class MetroRouter {
  // ! Route Names
  // onboarding
  static const String onboarding = '/';

  // authentication
  static const String login = '/login';
  static const String signUp = '/sign-up';

  // leaderboard
  static const String leaderboard = '/leaderboard';

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
            case leaderboard:
              return const MetroLeaderboardPage();
            case login:
              return const LogInView();
            case signUp:
              return const SignUpView();
            default:
              return const OnboardingView();
          }
        });
  }
}
