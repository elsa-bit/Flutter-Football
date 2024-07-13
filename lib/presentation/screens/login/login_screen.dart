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
import 'package:flutter_football/presentation/screens/login/reset_password_screen.dart';
import 'package:flutter_football/presentation/widgets/custom_text_field.dart';
import 'package:flutter_football/utils/extensions/text_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class _LoginScreen extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError = null;
  String? passwordError = null;
  String? loginError = null;
  FocusNode passwordFocusNode = FocusNode();

  void handleError(Exception error) {
    setState(() {
      final String errorMessage;
      if(error is AuthException) {
        errorMessage = "Les identifiants de connexion ne sont pas valides";
      } else {
        errorMessage = "Une erreur est survenue lors de la connexion";
      }
      loginError = errorMessage;
      passwordError = "";
      emailError = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LoginRepository(loginDataSource: LoginDataSource()),
      child: BlocProvider(
        create: (context) =>
            LoginBloc(
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

                if (state.authResponse != null) {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthenticateUser(auth: state.authResponse!));
                } else if (state.token != null) {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthenticateUserWithToken(token: state.token!));
                }

                LoadingDialog.hide(context);
                break;
              case LoginStatus.error:
                print("[Login] error");
                print(state.error);
                LoadingDialog.hide(context);
                if(state.error != null) handleError(state.error!);
                break;
            }
          },
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
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
                                icon: Icon(Icons.email),
                                controller: emailController,
                                error: emailError,
                                onChanged: (_) {
                                  if (emailError != null) {
                                    setState(() {
                                      emailError = null;
                                      loginError = null;
                                    });
                                  }
                                },
                                onEditingComplete: () {
                                  passwordFocusNode.requestFocus();
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                labelText: "Mot de passe",
                                hint: "*********",
                                icon: Icon(Icons.key),
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                obscureText: true,
                                error: passwordError,
                                onChanged: (_) {
                                  if (passwordError != null) {
                                    setState(() {
                                      passwordError = null;
                                      loginError = null;
                                    });
                                  }
                                },
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  this._login(context);
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentAppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            this._login(context);
                            },
                          child: Text(
                            "Se connecter",
                            style: AppTextStyle.subtitle1.copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, ResetPasswordScreen.route());
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: currentAppColors.secondaryTextColor,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    setState(() {
      emailError = null;
      passwordError = null;
      loginError = null;
    });
    print("Login ...");
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.add(
      Login(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }
}
