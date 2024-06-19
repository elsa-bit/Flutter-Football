import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PlayerRepository(
        playerDataSource: PlayerDataSource(),
        preferencesDataSource: SharedPreferencesDataSource(),
      ),
      child: BlocProvider(
        create: (context) => PlayersBloc(
          repository: RepositoryProvider.of<PlayerRepository>(context),
        )..add(GetFriendsPlayer(idPlayer: widget.idPlayer)),
        child: Scaffold(
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
                            final players = listPlayer[index];
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color:
                                      players.id.toString() == widget.idPlayer
                                          ? Color(0xa872acde)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  (index + 1).toString() + ".",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                              title: Text(
                                players.firstname + ' ' + players.lastname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.sports_soccer,
                                          color:
                                              currentAppColors.secondaryColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(players.goal.toString() ?? '')
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/yellow_card.svg',
                                              semanticsLabel: 'Yellow Card',
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                                players.yellowCard.toString() ??
                                                    '')
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/red_card.svg',
                                          semanticsLabel: 'Red Card',
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(players.redCard.toString() ?? '')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
