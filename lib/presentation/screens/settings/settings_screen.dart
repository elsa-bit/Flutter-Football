import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/utils/extensions/user_extension.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 350,
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    color: currentAppColors.secondaryTextColor,
                  ),
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
                              "Jean Pascal",//"${state.user?.getFirstname() ?? " "} ${state.user?.getLastname() ?? ""}",
                              style: AppTextStyle.subtitle2.copyWith(
                                  color: currentAppColors.secondaryColor),
                            ),
                            Spacer(),
                            Text(
                              "Entraineur U14",//state.user?.getRole() ?? "",
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
    );
  }
}
