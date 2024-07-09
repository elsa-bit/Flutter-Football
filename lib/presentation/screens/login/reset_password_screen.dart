import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/dialogs/lottie_dialog.dart';
import 'package:flutter_football/presentation/screens/login/token_reset_password_screen.dart';
import 'package:flutter_football/presentation/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = 'reset-password';

  ResetPasswordScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ResetPasswordScreen(),
    );
  }

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
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
                        "Mot de passe oublié",
                        style: AppTextStyle.title,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      "Nous allons vous envoyer un token pour réinitialiser votre mot de passe.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50,),
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
                          });
                        }
                      },
                      onEditingComplete: () {
                        this._resetPassword(context);
                      },
                    ),
                    SizedBox(height: 60,),
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
                        "Recevoir un Token",
                        style:
                            AppTextStyle.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, TokenResetPasswordScreen.route());
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          "J'ai déjà un token",
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
        ),
      );
    });
  }

  void _resetPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Ce champs doit être renseigné";
      });
      return;
    }
    try {
      LoadingDialog.show(context);
      await supabase.auth.resetPasswordForEmail(emailController.text);
      LoadingDialog.hide(context);
      await LottieDialog.show(context, "Votre token de réinitialisation a été envoyé sur votre adresse email !", assetName: 'assets/json/anim_email.json', repeat: false);
      Navigator.push(context, TokenResetPasswordScreen.route());
    } on AuthException catch(e) {
      LoadingDialog.hide(context);
      print(e.toString());
      setState(() {
        emailError = "Le mail n'est pas valide";
      });
    } catch(e) {
      LottieDialog.show(context, "Une erreur est survenue...", assetName: 'assets/json/anim_error.json', repeat: false);
    }
  }
}
