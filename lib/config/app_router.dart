import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/coach/match/match_screen.dart';
import 'package:flutter_football/presentation/screens/coach/schedule/playerAttendance_screen.dart';
import 'package:flutter_football/presentation/screens/coach/schedule/schedule_screen.dart';
import 'package:flutter_football/presentation/screens/coach/settings/settings_screen.dart';
import 'package:flutter_football/presentation/screens/coach/teams/teams_screen.dart';
import 'package:flutter_football/presentation/screens/login/login_screen.dart';
import 'package:flutter_football/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_football/presentation/screens/player/calendar/calendar_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/friend_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/rankingFriend_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/ranking_screen.dart';
import 'package:flutter_football/presentation/screens/splash/splash_screen.dart';

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
      case CalendarScreen.routeName:
        return CalendarScreen.route();
      case FriendScreen.routeName:
        return FriendScreen.route(settings);
      case RankingScreen.routeName:
        return RankingScreen.route(settings);
      case RankingFriendScreen.routeName:
        return RankingFriendScreen.route(settings);
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
