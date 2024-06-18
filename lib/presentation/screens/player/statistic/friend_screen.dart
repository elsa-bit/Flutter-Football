import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_event.dart';
import 'package:flutter_football/config/app_colors.dart';

class FriendScreen extends StatefulWidget {
  final int idPlayer;
  static const String routeName = '/player/friend';

  static void navigateTo(BuildContext context, int idPlayer) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, int>;
    final idPlayer = args['idPlayer']!;
    return MaterialPageRoute(
      builder: (context) => FriendScreen(idPlayer: idPlayer),
    );
  }

  const FriendScreen({
    Key? key,
    required this.idPlayer,
  }) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  String _scanQRcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un ami"),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                  WidgetStateProperty.all<Color>(
                      AppColors.lightBlue),
                ),
                onPressed: () =>
                    QrCodeScan(),
                child: Text(
                  "Scanner le QrCode de mon ami",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void QrCodeScan(){

  }
}
