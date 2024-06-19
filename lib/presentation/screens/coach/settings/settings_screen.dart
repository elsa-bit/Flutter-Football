import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/utils/extensions/user_extension.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SettingsScreen(),
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? avatarUrl;
  late String identifier;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthBloc>(context).state.user;
    identifier = "${user?.id}${user?.getFirstname()}";
    BlocProvider.of<MediaBloc>(context)
        .add(GetAvatar(imageName: user?.getAvatar(), identifier: identifier));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaBloc, MediaState>(
      listener: (context, state) {
        switch (state.status) {
          case MediaStatus.success:
            if(state.response?.identifier == identifier) {
              setState(() {
                avatarUrl = state.response?.url;
              });
            }
            break;
          case MediaStatus.error:
            break;
          default:
            break;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 350,
                child: Stack(
                  children: [
                    if (avatarUrl != null) ...[
                      Image.network(
                        avatarUrl!,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    ] else
                      ...[
                        Container(
                          height: 300,
                          color: currentAppColors.secondaryTextColor,
                        ),
                      ],
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          height: 100,
                          width: 250,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Spacer(flex: 2),
                              Text(
                                "${state.user?.getFirstname() ?? " "} ${state
                                    .user?.getLastname() ?? ""}",
                                style: AppTextStyle.subtitle2.copyWith(
                                    color: currentAppColors.secondaryColor),
                              ),
                              Spacer(),
                              Text(
                                state.user?.getRole() ?? "",
                                style: AppTextStyle.regular.copyWith(
                                    color: currentAppColors.secondaryColor),
                              ),
                              Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(Logout());
                },
                child: Text(
                  "Déconnexion",
                  style: AppTextStyle.subtitle1.copyWith(color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        },
      ),
    );
  }
}
