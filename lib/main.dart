import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_football/config/app_router.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/networking/firebase/firebase_analytics_handler.dart';
import 'package:flutter_football/presentation/screens/home.dart';
import 'package:flutter_football/presentation/screens/login/login_screen.dart';
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
  // set up the currentAppColors based on the device theme (Dark or Light)
  var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  currentAppColors = brightness == Brightness.dark ? DarkThemeAppColors() : LightThemeAppColors();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO : implement Go_router
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
        home: RouteManager(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        //initialRoute: SplashScreen.routeName,
      ),
    );
  }
}

class RouteManager extends StatefulWidget {
  const RouteManager({Key? key}) : super(key: key);

  @override
  State<RouteManager> createState() => _RouteManagerState();
}

class _RouteManagerState extends State<RouteManager> {
  late Widget rootWidget = LoginScreen(onLoginCallback: () => onLogin());

  void onLogin() {
    setState(() {
      rootWidget = Home();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: rootWidget
    );
  }
}

