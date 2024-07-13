import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/match/selection/player_selection_item.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_item.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_selectable_horizontal_item.dart';

class SelectionScreen extends StatefulWidget {
  static const String routeName = 'selection';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) =>
          SelectionScreen(
            match: match,
          ),
    );
  }

  const SelectionScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<Player>? allPlayers;
  List<Player> selectedPlayers = [];
  bool validationEnabled = false;


  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context)
        .add(GetPlayersTeam(teamId: widget.match.idTeam));
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayersBloc, PlayersState>(
          listener: (context, state) {
            switch (state.status) {
              case PlayersStatus.loading:
                LoadingDialog.show(context);
                break;
              case PlayersStatus.success:
                LoadingDialog.hide(context);
                setState(() {
                  allPlayers = state.players;
                });
                break;
              default:
                LoadingDialog.hide(context);
                break;
            }
          },
        ),
        BlocListener<MatchBloc, MatchState>(
          listener: (context, state) {
            switch (state.status) {
              case MatchStatus.redirect:
                Navigator.of(context).popUntil((route) => route.isFirst);
                break;
              default:
                LoadingDialog.hide(context);
                break;
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sélection ${widget.match.nameTeam}"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Ma sélection :",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 150,
              child: ListView.separated(
                itemCount: selectedPlayers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final player = selectedPlayers[index];
                  return PlayerSelectionItem(
                    player: player,
                    onTap: () => onPlayerSelectionTap(player),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 15,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                if (validationEnabled) {
                  BlocProvider.of<MatchBloc>(context).add(SetSelection(widget.match, selectedPlayers.map((p) => p.id.toString()).toList()));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                width: 200.0,
                decoration: BoxDecoration(
                  color: validationEnabled ? AppColors.mediumBlue : currentAppColors.primaryVariantColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Valider la séléction",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: validationEnabled ? AppColors.white : currentAppColors.secondaryTextColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: currentAppColors.primaryVariantColor1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Faites la sélection des joueurs titulaires pour ce match.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          children: List.generate(allPlayers?.length ?? 0, (index) {
                            final player = allPlayers![index];
                            return PlayerSelectionItem(
                              player: player,
                              onTap: () => onPlayerTap(player),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPlayerTap(Player player) {
    setState(() {
      if (selectedPlayers.length == 11) {
        // show pop up ?
        return;
      }
      selectedPlayers.insert(0, player);
      allPlayers?.remove(player);

      if (selectedPlayers.length == 11) {
        validationEnabled = true;
      }
    });
  }

  void onPlayerSelectionTap(Player player) {
    setState(() {
      selectedPlayers.remove(player);
      allPlayers?.insert(0, player);
      if (selectedPlayers.length < 11) {
        validationEnabled = false;
      }
    });
  }
}
