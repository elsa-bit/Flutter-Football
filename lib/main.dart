import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_football/config/app_router.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/networking/firebase/firebase_analytics_handler.dart';
import 'package:flutter_football/presentation/screens/match/match_screen.dart';
import 'package:flutter_football/presentation/screens/schedule/schedule_screen.dart';
import 'package:flutter_football/presentation/screens/settings/settings_screen.dart';
import 'package:flutter_football/presentation/screens/teams/teams_screen.dart';
import 'package:flutter_football/presentation/widgets/bottom_nav_bar.dart';
import 'config/app_colors.dart';
import 'networking/firebase/analytics_provider.dart';
import 'networking/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnalyticsProvider(
      handlers: [
        FirebaseAnalyticsHandler(),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const Home(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        //initialRoute: SplashScreen.routeName,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final screens = [
    const ScheduleScreen(),
    const TeamsScreen(),
    const MatchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // set up the currentAppColors based on the device theme (Dark or Light)
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    currentAppColors = brightness == Brightness.dark ? LightThemeAppColors() : DarkThemeAppColors();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        setIndexOfButton: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
