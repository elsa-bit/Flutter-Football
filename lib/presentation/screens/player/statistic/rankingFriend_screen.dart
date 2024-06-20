import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/player/statistic/ranking_item.dart';

class RankingFriendScreen extends StatefulWidget {
  static const String routeName = '/player/rankingFriend';
  final String idPlayer;

  const RankingFriendScreen({Key? key, required this.idPlayer})
      : super(key: key);

  static void navigateTo(BuildContext context, String idPlayer) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idPlayer = args['idPlayer']!;
    return MaterialPageRoute(
      builder: (context) => RankingFriendScreen(idPlayer: idPlayer),
    );
  }

  @override
  State<RankingFriendScreen> createState() => _RankingFriendScreenState();
}

class _RankingFriendScreenState extends State<RankingFriendScreen> {
  String _selectedCriteria = 'buts';

  @override
  void initState() {
    super.initState();
    final playerBloc = context.read<PlayersBloc>();
    playerBloc.add(GetFriendsPlayer(idPlayer: widget.idPlayer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayersBloc, PlayersState>(
        builder: (context, state) {
          switch (state.status) {
            case PlayersStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PlayersStatus.error:
              return Center(
                child: Text(
                  state.error,
                ),
              );
            case PlayersStatus.success:
            default:
              var listPlayer = state.players;
              if (listPlayer == null || listPlayer.isEmpty) {
                return const Center(
                  child: Text("Aucun joueur reconnu !"),
                );
              }

              if (_selectedCriteria == 'buts') {
                listPlayer.sort((a, b) => b.goal.compareTo(a.goal));
              } else if (_selectedCriteria == 'carton rouge') {
                listPlayer.sort((a, b) => b.redCard.compareTo(a.redCard));
              } else if (_selectedCriteria == 'carton jaune') {
                listPlayer
                    .sort((a, b) => b.yellowCard.compareTo(a.yellowCard));
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      children: [
                        Text(
                          "Trier par ",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        DropdownButton<String>(
                          value: _selectedCriteria,
                          items: <String>[
                            'buts',
                            'carton rouge',
                            'carton jaune'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCriteria = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listPlayer.length,
                      itemBuilder: (context, index) {
                        final player = listPlayer[index];
                        return RankingItem(
                          player: player,
                          idPlayer: widget.idPlayer,
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
