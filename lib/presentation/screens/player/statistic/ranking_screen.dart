import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/player/statistic/rankingFriend_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/rankingTeam_screen.dart';

class RankingScreen extends StatefulWidget {
  static const String routeName = '/player/ranking';
  final String idPlayer;

  const RankingScreen({Key? key, required this.idPlayer})
      : super(key: key);

  static void navigateTo(
      BuildContext context, String idPlayer) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idPlayer = args['idPlayer']!;
    return MaterialPageRoute(
      builder: (context) => RankingScreen(idPlayer: idPlayer),
    );
  }

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int sharedValue = 0;
  final Map<int, Widget> pickerRanking = const <int, Widget>{
    0: Text("Amis"),
    1: Text("Equipes"),
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
        return RankingFriendScreen(idPlayer: widget.idPlayer);
      case 1:
        return RankingTeamScreen(idPlayer: widget.idPlayer);
      default:
        return RankingFriendScreen(idPlayer: widget.idPlayer);
    }
  }
}
