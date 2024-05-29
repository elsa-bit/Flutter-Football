import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/utils/extensions/text_extension.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final Function onLoginCallback;

  LoginScreen({Key? key, required this.onLoginCallback}) : super(key: key);

  //LoginScreen({super.key, required this.onLoginCallback});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => LoginScreen(
        onLoginCallback: () {},
      ),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
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
                  constraints: const BoxConstraints.expand(width: 100.0),
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
              Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Email",
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Mot de passe",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
