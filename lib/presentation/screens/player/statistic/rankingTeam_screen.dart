import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_bloc.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';
import 'package:flutter_football/presentation/screens/player/statistic/ranking_item.dart';

class RankingTeamScreen extends StatefulWidget {
  static const String routeName = '/player/rankingTeam';
  final String idPlayer;
  final String idTeams;

  const RankingTeamScreen(
      {Key? key, required this.idPlayer, required this.idTeams})
      : super(key: key);

  static void navigateTo(
      BuildContext context, String idPlayer, String idTeams) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer, 'idTeams': idTeams},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idPlayer = args['idPlayer']!;
    final idTeams = args['idTeams']!;
    return MaterialPageRoute(
      builder: (context) =>
          RankingTeamScreen(idPlayer: idPlayer, idTeams: idTeams),
    );
  }

  @override
  State<RankingTeamScreen> createState() => _RankingTeamScreenState();
}

class _RankingTeamScreenState extends State<RankingTeamScreen> {
  String _selectedCriteria = 'buts';
  String? _selectedTeam = null;

  @override
  void initState() {
    super.initState();
    final teamsBloc = BlocProvider.of<TeamsBloc>(context);
    final playersBloc = BlocProvider.of<PlayersBloc>(context);

    teamsBloc.add(GetSpecificTeamPlayer(idPlayer: widget.idPlayer));
    if (_selectedTeam != null) {
      playersBloc.add(GetPlayersTeam(teamId: _selectedTeam!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<TeamsBloc, TeamState>(
            builder: (context, teamState) {
              switch (teamState.status) {
                case TeamStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case TeamStatus.error:
                  return Center(
                    child: Text(
                      teamState.error,
                    ),
                  );
                case TeamStatus.success:
                default:
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: _selectedTeam,
                                hint: Text('Equipe'),
                                items: teamState.teams!.map((team) {
                                  return DropdownMenuItem<String>(
                                    value: team.id.toString(),
                                    child: Text(team.name),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedTeam = newValue;
                                    if (_selectedTeam != null) {
                                      BlocProvider.of<PlayersBloc>(context).add(
                                          GetPlayersTeam(
                                              teamId: _selectedTeam!));
                                    }
                                  });
                                },
                              ),
                              Container(
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
                            ],
                          ),
                        ),
                        BlocBuilder<PlayersBloc, PlayersState>(
                          builder: (context, playerState) {
                            if (_selectedTeam == null) {
                              return Center(
                                child: Text("Sélectionnez une équipe pour afficher les joueurs"),
                              );
                            }

                            switch (playerState.status) {
                              case PlayersStatus.loading:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case PlayersStatus.error:
                                return Center(
                                  child: Text(playerState.error),
                                );
                              case PlayersStatus.success:
                              default:
                                var listPlayer = playerState.players;
                                if (listPlayer == null || listPlayer.isEmpty) {
                                  return const Center(
                                    child: Text("Aucun joueur reconnu !"),
                                  );
                                }

                                if (_selectedCriteria == 'buts') {
                                  listPlayer
                                      .sort((a, b) => b.goal.compareTo(a.goal));
                                } else if (_selectedCriteria ==
                                    'carton rouge') {
                                  listPlayer.sort(
                                      (a, b) => b.redCard.compareTo(a.redCard));
                                } else if (_selectedCriteria ==
                                    'carton jaune') {
                                  listPlayer.sort((a, b) =>
                                      b.yellowCard.compareTo(a.yellowCard));
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: listPlayer.length,
                                  itemBuilder: (context, index) {
                                    final player = listPlayer[index];
                                    return RankingItem(
                                      player: player,
                                      idPlayer: widget.idPlayer,
                                      index: index,
                                    );
                                  },
                                );
                            }
                          },
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
