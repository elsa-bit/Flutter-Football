import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/dialogs/lottie_dialog.dart';
import 'package:flutter_football/presentation/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstLoginScreen extends StatefulWidget {
  static const String routeName = 'first-login';
  final AuthResponse authResponse;

  FirstLoginScreen({Key? key, required this.authResponse}) : super(key: key);

  static Route route(AuthResponse authResponse) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => FirstLoginScreen(
        authResponse: authResponse,
      ),
    );
  }

  @override
  State<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool? isSamePassword = null;
  final _controller = ConfettiController(duration: Duration(seconds: 5));

  @override
  void initState() {
    super.initState();
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\ud83c\udf89",
                              style: TextStyle(
                                fontSize: 50,
                              ),
                            ),
                            Transform.flip(
                              flipX: true,
                              child: Text(
                                "\ud83c\udf89",
                                style: TextStyle(
                                  fontSize: 50,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                        ConfettiWidget(
                          confettiController: _controller,
                          blastDirectionality: BlastDirectionality.explosive,
                          colors: const [
                            Colors.indigo,
                            Colors.blue,
                            Colors.redAccent
                          ],
                          //gravity: 0.5,
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        "Bienvenue",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: currentAppColors.primaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "C'est ta première connexion sur notre application !\n-\nChoisis ton mot de passe pour te connecter à ton compte.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    CustomTextField(
                      labelText: "Mot de passe",
                      hint: "********",
                      icon: Icon(Icons.key),
                      onChanged: (value) {
                        if (confirmPasswordController.text.isNotEmpty) {
                          setState(() {
                            isSamePassword =
                                value == confirmPasswordController.text;
                          });
                        }
                      },
                      obscureText: true,
                      controller: passwordController,
                      onEditingComplete: () {
                        passwordFocusNode.requestFocus();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      labelText: "Confirmer mot de passe",
                      hint: "********",
                      icon: Icon(Icons.key),
                      controller: confirmPasswordController,
                      focusNode: passwordFocusNode,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isSamePassword = null;
                          });
                          return;
                        }
                        setState(() {
                          isSamePassword = value == passwordController.text;
                        });
                      },
                      obscureText: true,
                      error: (isSamePassword == false) ? "" : null,
                      onEditingComplete: () {
                        if (isSamePassword == true)
                          this._resetPassword(context);
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (isSamePassword == true)
                            ? currentAppColors.secondaryColor
                            : currentAppColors.primaryVariantColor2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        if (isSamePassword == true)
                          this._resetPassword(context);
                      },
                      child: Text(
                        "Confirmer",
                        style: AppTextStyle.subtitle1.copyWith(
                            color: (isSamePassword == true)
                                ? Colors.white
                                : currentAppColors.secondaryTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _resetPassword(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      await supabase.auth.updateUser(
        UserAttributes(password: passwordController.text),
      );

      LoadingDialog.hide(context);
      await LottieDialog.show(
          context, "Votre mot de passe a bien été enregistré !",
          assetName: 'assets/json/anim_success.json', repeat: false);

      BlocProvider.of<AuthBloc>(context).add(AuthenticateUser(auth: widget.authResponse));
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      bool redirectToLogin = false;
      String errorMessage =
          "Une erreur est survenue...\nVérifier que tous les champs soient remplis";
      if (e.statusCode == '403') {
        errorMessage =
            "Votre Token est arrivé à expiration ou ne correspond pas à votre email.";
      } else if (e.statusCode == '422') {
        if (e.message.contains("password")) {
          errorMessage =
              "Votre nouveau mot de passe doit être different de votre ancien mot de passe.\n\nVous allez être redirigé vers la page de connexion.";
          redirectToLogin = true;
        } else {
          errorMessage = "Votre email est invalide.";
        }
      }
      LoadingDialog.hide(context);
      print(e.toString());
      await LottieDialog.show(context, errorMessage,
          assetName: 'assets/json/anim_error.json', repeat: false);
      if (redirectToLogin)
        Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      await LottieDialog.show(context, "Une erreur est survenue...",
          assetName: 'assets/json/anim_error.json', repeat: false);
    }
  }
}
