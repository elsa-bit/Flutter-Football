import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/login/login_screen.dart';
import 'package:flutter_football/presentation/screens/match/match_screen.dart';
import 'package:flutter_football/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_football/presentation/screens/schedule/playerAttendance_screen.dart';
import 'package:flutter_football/presentation/screens/schedule/schedule_screen.dart';
import 'package:flutter_football/presentation/screens/settings/settings_screen.dart';
import 'package:flutter_football/presentation/screens/splash/splash_screen.dart';
import 'package:flutter_football/presentation/screens/teams/teams_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');

    print(settings);
    switch (settings.name) {
      case '/':
        return ScheduleScreen.route();
      case ScheduleScreen.routeName:
        return ScheduleScreen.route();
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case TeamsScreen.routeName:
        return TeamsScreen.route();
      case MatchScreen.routeName:
        return MatchScreen.route();
      case SettingsScreen.routeName:
        return SettingsScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case PlayerAttendanceScreen.routeName:
        return PlayerAttendanceScreen.route(settings);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
      settings: RouteSettings(name: '/error'),
    );
  }
}
