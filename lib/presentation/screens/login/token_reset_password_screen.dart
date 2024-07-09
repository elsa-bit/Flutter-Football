import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/dialogs/lottie_dialog.dart';
import 'package:flutter_football/presentation/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TokenResetPasswordScreen extends StatefulWidget {
  static const String routeName = 'reset-password-token';

  TokenResetPasswordScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TokenResetPasswordScreen(),
    );
  }

  @override
  State<TokenResetPasswordScreen> createState() => _TokenResetPasswordScreenState();
}

class _TokenResetPasswordScreenState extends State<TokenResetPasswordScreen> {
  final resetTokenController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  String? emailError = null;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
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
                        "Réinitialisation du mot de passe",
                        style: AppTextStyle.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      "Créer un nouveau mot de passe avec le Token reçue par email",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50,),
                    CustomTextField(
                      labelText: "Reset Token",
                      hint: "123456",
                      icon: Icon(Icons.auto_awesome_outlined),
                      controller: resetTokenController,
                      //error: emailError,
                      onChanged: (_) {
                      },
                      onEditingComplete: () {
                        emailFocusNode.requestFocus();
                      },
                    ),
                    SizedBox(height: 15,),
                    CustomTextField(
                      labelText: "Email",
                      hint: "email@gmail.com",
                      icon: Icon(Icons.email),
                      controller: emailController,
                      error: emailError,
                      focusNode: emailFocusNode,
                      onChanged: (_) {
                        if (emailError != null) {
                          setState(() {
                            emailError = null;
                          });
                        }
                      },
                      onEditingComplete: () {
                        passwordFocusNode.requestFocus();
                      },
                    ),
                    SizedBox(height: 15,),
                    CustomTextField(
                      labelText: "Nouveau mot de passe",
                      hint: "********",
                      icon: Icon(Icons.key),
                      controller: passwordController,
                      //error: emailError,
                      focusNode: passwordFocusNode,
                      onChanged: (_) {
                      },
                      onEditingComplete: () {
                        this._resetPassword(context);
                      },
                    ),
                    SizedBox(height: 40,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentAppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        this._resetPassword(context);
                      },
                      child: Text(
                        "Réinitialiser",
                        style:
                        AppTextStyle.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
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
      final recovery = await supabase.auth.verifyOTP(
        email: emailController.text,
        token: resetTokenController.text,
        type: OtpType.recovery,
      );
      print(recovery);
      await supabase.auth.updateUser(
        UserAttributes(password: passwordController.text),
      );

      LoadingDialog.hide(context);
      await LottieDialog.show(context, "Votre mot de passe a bien été réinitialisé !", assetName: 'assets/json/anim_success.json', repeat: false);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch(e) {
      bool redirectToLogin = false;
      String errorMessage = "Une erreur est survenue...\nVérifier que tout le champs soient remplis";
      if (e.statusCode == '403') {
        errorMessage = "Votre Token est arrivé à expiration ou ne correspond pas à votre email.";
      } else if (e.statusCode == '422') {
        if (e.message.contains("password")) {
          errorMessage = "Votre nouveau mot de passe doit être different de votre ancien mot de passe.\n\nVous allez être redirigé vers la page de connexion.";
          redirectToLogin = true;
        } else {
          errorMessage = "Votre email est invalide.";
        }
      }
      LoadingDialog.hide(context);
      print(e.toString());
      await LottieDialog.show(context, errorMessage, assetName: 'assets/json/anim_error.json', repeat: false);
      if(redirectToLogin) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch(e) {
      await LottieDialog.show(context, "Une erreur est survenue...", assetName: 'assets/json/anim_error.json', repeat: false);
    }
  }
}
