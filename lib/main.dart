import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_router.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/repositories/auth_repository.dart';
import 'package:flutter_football/networking/firebase/firebase_analytics_handler.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/presentation/screens/home.dart';
import 'package:flutter_football/presentation/screens/login/login_screen.dart';
import 'package:flutter_football/presentation/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'config/app_colors.dart';
import 'networking/firebase/analytics_provider.dart';
import 'networking/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://lbsteoacojxblwiyfbye.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxic3Rlb2Fjb2p4Ymx3aXlmYnllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM2OTQ3NzgsImV4cCI6MjAyOTI3MDc3OH0.t1aFfSzTE1fyg4nG3GIYEKPqD2DetaqfTgXS92slZGo",
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // set up the currentAppColors based on the device theme (Dark or Light)
  var brightness = SchedulerBinding.instance.platformDispatcher
      .platformBrightness;
  currentAppColors =
  brightness == Brightness.dark ? DarkThemeAppColors() : LightThemeAppColors();

  runApp(const MyApp());
}


final supabase = Supabase.instance.client;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO : implement Go_router
  // TODO : implement theme_tailor
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: AnalyticsProvider(
        handlers: [
          FirebaseAnalyticsHandler(),
        ],
        child: BlocProvider(
          create: (context) =>
          AuthBloc(
            repository: RepositoryProvider.of<AuthRepository>(context),
          )
            ..add(IsUserAuthenticated()),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                switch(state.status) {

                  case AuthStatus.authenticated:
                    return const Home();
                    break;
                  case AuthStatus.unauthenticated:
                    return LoginScreen();
                    break;
                  case AuthStatus.error:
                    // TODO: Handle this case.
                    //break;
                  default:
                    // For default and AuthStatus.unknown
                    // TODO : Show Splash screen
                    return const SplashScreen();
                    break;
                }
                //return RouteManager();
              },
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            //initialRoute: SplashScreen.routeName,
          ),
        ),
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
  late Widget rootWidget = LoginScreen();

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

