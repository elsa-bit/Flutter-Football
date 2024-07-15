import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_router.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/data/data_sources/auth_data_source.dart';
import 'package:flutter_football/data/data_sources/coach_data_source.dart';
import 'package:flutter_football/data/data_sources/match_data_source.dart';
import 'package:flutter_football/data/data_sources/conversation_data_source.dart';
import 'package:flutter_football/data/data_sources/media_data_source.dart';
import 'package:flutter_football/data/data_sources/message_data_source.dart';
import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/domain/repositories/auth_repository.dart';
import 'package:flutter_football/domain/repositories/coach_repository.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/domain/repositories/conversation_repository.dart';
import 'package:flutter_football/domain/repositories/media_repository.dart';
import 'package:flutter_football/domain/repositories/message_repository.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/domain/repositories/schedule_repository.dart';
import 'package:flutter_football/domain/repositories/team_repository.dart';
import 'package:flutter_football/networking/firebase/firebase_analytics_handler.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/message/message_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_bloc.dart';
import 'package:flutter_football/presentation/dialogs/player_forbidden_access_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/home.dart';
import 'package:flutter_football/presentation/screens/login/login_screen.dart';
import 'package:flutter_football/presentation/screens/player/home_player.dart';
import 'package:flutter_football/presentation/screens/splash/splash_screen.dart';
import 'package:flutter_football/utils/shared_preferences_utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'config/app_colors.dart';
import 'data/data_sources/schedule_data_source.dart';
import 'data/data_sources/shared_preferences_data_source.dart';
import 'networking/firebase/analytics_provider.dart';
import 'networking/firebase/firebase_options.dart';
import 'presentation/blocs/match/match_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://lbsteoacojxblwiyfbye.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxic3Rlb2Fjb2p4Ymx3aXlmYnllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM2OTQ3NzgsImV4cCI6MjAyOTI3MDc3OH0.t1aFfSzTE1fyg4nG3GIYEKPqD2DetaqfTgXS92slZGo",
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  await SharedPreferencesUtils.init();

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // set up the currentAppColors based on the device theme (Dark or Light)
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  currentAppColors = brightness == Brightness.dark
      ? DarkThemeAppColors()
      : LightThemeAppColors();

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void listenAuthState(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.error:
        print(state.error);
        break;
      case AuthStatus.playerAccessForbidden:
        PlayerForbiddenAccessDialog.show(context);
        break;
      case AuthStatus.authenticatedAsCoach:
      case AuthStatus.authenticatedAsPlayer:
        print("Authenticated !");
        break;
      case AuthStatus.unauthenticated:
        print("Authentication failed.");
        break;
      default:
        return;
    }
  }

  // TODO : implement Go_router
  // TODO : implement theme_tailor
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            preferencesDataSource: SharedPreferencesDataSource(),
            authDataSource: AuthDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MediaRepository(
            mediaDataSource: MediaDataSource(),
            preferencesDataSource: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ScheduleRepository(
            scheduleDataSource: ScheduleDataSource(),
            preferencesDataSource: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => PlayerRepository(
            playerDataSource: PlayerDataSource(),
            preferencesDataSource: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MatchRepository(
            matchDataSource: MatchDataSource(),
            preferencesDataSource: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TeamRepository(
            teamDataSource: TeamDataSource(),
            preferences: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ConversationRepository(
            conversationDataSource: ConversationDataSource(),
            preferences: SharedPreferencesDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MessageRepository(
            messageDataSource: MessageDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => CoachRepository(
            coachDataSource: CoachDataSource(),
            preferencesDataSource: SharedPreferencesDataSource(),
          ),
        ),
      ],
      child: AnalyticsProvider(
        handlers: [
          FirebaseAnalyticsHandler(),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                repository: RepositoryProvider.of<AuthRepository>(context),
              )..add(IsUserAuthenticated()),
            ),
            BlocProvider(
              create: (context) => ScheduleBloc(
                repository: RepositoryProvider.of<ScheduleRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => PlayersBloc(
                repository: RepositoryProvider.of<PlayerRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => MediaBloc(
                repository: RepositoryProvider.of<MediaRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => FmiBloc(
                repository: RepositoryProvider.of<MatchRepository>(context),
                playerRepository:
                    RepositoryProvider.of<PlayerRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => TeamsBloc(
                repository: RepositoryProvider.of<TeamRepository>(context),
                matchRepository: RepositoryProvider.of<MatchRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => ConversationBloc(
                repository:
                    RepositoryProvider.of<ConversationRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => MessageBloc(
                repository: RepositoryProvider.of<MessageRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => MatchBloc(
                repository: RepositoryProvider.of<MatchRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => CoachBloc(
                repository: RepositoryProvider.of<CoachRepository>(context),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: Builder(builder: (context) {
              return BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  listenAuthState(context, state);
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case AuthStatus.authenticatedAsCoach:
                        return const Home();
                      case AuthStatus.authenticatedAsPlayer:
                        return HomePlayer();
                      case AuthStatus.unauthenticated:
                      case AuthStatus.playerAccessForbidden:
                        return LoginScreen();
                      default:
                        return const SplashScreen();
                    }
                  },
                ),
              );
            }),
            onGenerateRoute: AppRouter.onGenerateRoute,
            //initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}
