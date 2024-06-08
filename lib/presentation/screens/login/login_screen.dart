import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/data/data_sources/login/login_data_source.dart';
import 'package:flutter_football/domain/repositories/login_repository.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_football/presentation/blocs/login/login_event.dart';
import 'package:flutter_football/presentation/blocs/login/login_state.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/widgets/custom_text_field.dart';
import 'package:flutter_football/utils/extensions/text_extension.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

// Conditional widget creation (for Column, List, etc.)
/*
if (_selectedIndex == 0) ...[
          DayScreen(),
        ] else ...[
          StatsScreen(),
        ],
 */

class _LoginScreen extends State<LoginScreen> {
  late final Function onLoginCallback;
  TextStyle selectedTextStyle =
      AppTextStyle.subtitle1.copyWith(color: currentAppColors.secondaryColor);
  TextStyle unselectedTextStyle =
      AppTextStyle.regular.copyWith(color: currentAppColors.secondaryTextColor);
  List<bool> _loginSelections = [true, false];
  List<Text> _loginWidgets = [
    Text(
      "Coach",
      style: AppTextStyle.subtitle1
          .copyWith(color: currentAppColors.secondaryColor),
    ),
    Text(
      "Adhérent",
      style: AppTextStyle.regular
          .copyWith(color: currentAppColors.secondaryTextColor),
    ),
  ];
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError = null;
  String? passwordError = null;
  String? loginError = null;

  void handleError(String error) {
    setState(() {
      if (error.contains("Email")) {
        emailError = error;
      } else if (error.contains("Mot de passe")) {
        passwordError = error;
      } else {
        loginError = error;
        passwordError = "";
        emailError = "";
      }
    });
  }

  void updateSelectionState(int index) {
    _loginSelections[index] = !_loginSelections[index];
    _loginWidgets[index] = _loginWidgets[index].copyWith(
      style: _loginSelections[index] ? selectedTextStyle : unselectedTextStyle,
    );

    final otherIndex = (index + 1) % 2;
    if (_loginSelections[otherIndex] == true) {
      _loginSelections[otherIndex] = false;
      _loginWidgets[otherIndex] = _loginWidgets[otherIndex].copyWith(
        style: unselectedTextStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LoginRepository(loginDataSource: LoginDataSource()),
      child: BlocProvider(
        create: (context) => LoginBloc(
          repository: RepositoryProvider.of<LoginRepository>(context),
        ),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            switch (state.status) {
              case LoginStatus.initial:
                break;
              case LoginStatus.loading:
                print("[Login] loading");
                LoadingDialog.show(context);
                break;
              case LoginStatus.success:
                print("[Login] success");

                if(state.authResponse != null) {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthenticateUser(auth: state.authResponse!));
                } else if(state.token != null) {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthenticateUserWithToken(token: state.token!));
                }

                LoadingDialog.hide(context);
                break;
              case LoginStatus.error:
                print("[Login] error");
                print(state.error);
                LoadingDialog.hide(context);
                handleError(state.error.toString());
                break;
            }
          },
          child: Builder(builder: (context) {
            return Scaffold(
              body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 60.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/CSB.png",
                        width: 70.0,
                        height: 70.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child: ToggleButtons(
                          isSelected: _loginSelections,
                          //textStyle: AppTextStyle.regular,
                          selectedColor: currentAppColors.secondaryColor,
                          onPressed: (int index) {
                            setState(() {
                              updateSelectionState(index);
                            });
                          },
                          constraints:
                              const BoxConstraints.expand(width: 100.0),
                          children: _loginWidgets,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          "Connexion",
                          style: AppTextStyle.title,
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            CustomTextField(
                              labelText: "Email",
                              hint: "email@gmail.com",
                              controller: emailController,
                              error: emailError,
                              onChanged: (_) {
                                if (emailError != null) {
                                  setState(() {
                                    emailError = null;
                                  });
                                }
                              },
                            ),
                            CustomTextField(
                              labelText: "Mot de passe",
                              hint: "*********",
                              controller: passwordController,
                              obscureText: true,
                              error: passwordError,
                              onChanged: (_) {
                                if (passwordError != null) {
                                  setState(() {
                                    passwordError = null;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      if (loginError != null) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            loginError!,
                            style: AppTextStyle.regular.copyWith(
                                color: Color.fromRGBO(207, 156, 149, 1.0)),
                          ),
                        ),
                      ] else
                        ...[],
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              emailError = null;
                              passwordError = null;
                              loginError = null;
                            });
                            print("Login ...");
                            final loginBloc =
                            BlocProvider.of<LoginBloc>(context);
                            loginBloc.add(
                              Login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          },
                          child: const Text("Se connecter")),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
