import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/player/profil/contact_screen.dart';
import 'package:flutter_football/presentation/screens/player/profil/rule_screen.dart';


class InfoClubScreen extends StatefulWidget {
  static const String routeName = '/player/infoClub';

  const InfoClubScreen({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => InfoClubScreen(),
    );
  }

  @override
  State<InfoClubScreen> createState() => _InfoClubScreenState();
}

class _InfoClubScreenState extends State<InfoClubScreen> {
  int sharedValue = 0;
  final Map<int, Widget> pickerRanking = const <int, Widget>{
    0: Text("Contacts"),
    1: Text("Règlement du club"),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          SizedBox(
            width: 500.0,
            child: CupertinoSegmentedControl(
              children: pickerRanking,
              onValueChanged: (int val) {
                setState(() {
                  sharedValue = val;
                });
              },
              groupValue: sharedValue,
              selectedColor: Colors.blue,
              borderColor: Colors.blue,
              pressedColor: Colors.blue.withOpacity(0.3),
            ),
          ),
          Expanded(
            child: _getSelectedScreen(sharedValue),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen(int value) {
    switch (value) {
      case 0:
        return ContactScreen();
      case 1:
        return RuleScreen();
      default:
        return ContactScreen();
    }
  }
}
