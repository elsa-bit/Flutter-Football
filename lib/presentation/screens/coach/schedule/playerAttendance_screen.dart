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

class PlayerAttendanceScreen extends StatefulWidget {
  final String idTeam;
  final String idEvent;
  static const String routeName = '/PlayerAttendanceScreen';

  static void navigateTo(BuildContext context, String idTeam, String idEvent) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idTeam': idTeam, 'idEvent': idEvent},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idTeam = args['idTeam']!;
    final idEvent = args['idEvent']!;
    return MaterialPageRoute(
      builder: (context) =>
          PlayerAttendanceScreen(idTeam: idTeam, idEvent: idEvent),
    );
  }

  const PlayerAttendanceScreen({
    Key? key,
    required this.idTeam,
    required this.idEvent,
  }) : super(key: key);

  @override
  State<PlayerAttendanceScreen> createState() => _PlayerAttendanceScreenState();
}

class _PlayerAttendanceScreenState extends State<PlayerAttendanceScreen> {
  List<int> _selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PlayerRepository(
          playerDataSource: PlayerDataSource(),
          preferencesDataSource: SharedPreferencesDataSource()),
      child: BlocProvider(
        create: (context) => PlayersBloc(
          repository: RepositoryProvider.of<PlayerRepository>(context),
        )..add(GetPlayersTeam(teamId: widget.idTeam)),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Présence"),
            backgroundColor: currentAppColors.secondaryColor,
          ),
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
                  if (state.players!.isEmpty) {
                    return const Center(
                      child: Text("Il n'y a pas de joueurs dans cette équipe."),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.players!.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              activeColor: currentAppColors.secondaryColor,
                              title: Text(
                                  "${state.players![index].firstname} ${state.players![index].lastname}"),
                              value: _selectedPlayers
                                  .contains(state.players![index].id),
                              onChanged: (bool? isChecked) {
                                setState(() {
                                  if (isChecked!) {
                                    _selectedPlayers.add(
                                        int.parse(state.players![index].id));
                                  } else {
                                    _selectedPlayers
                                        .remove(state.players![index].id);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.lightBlue)),
                          onPressed: () {
                            _onAddPlayerAttendance(context);
                          },
                          child: Text("Enregistrer"),
                        ),
                      ),
                    ],
                  );
                default:
                  return const Center(
                    child: Text("Il n'y a pas de joueurs dans cette équipe."),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onAddPlayerAttendance(BuildContext context) async {
    var bloc = BlocProvider.of<ScheduleBloc>(context);

    if (_selectedPlayers.isNotEmpty) {
      var idPlayersString = _selectedPlayers.join(",");

      bloc.add(AddPlayerAttendance(
          idEvent: widget.idEvent, idPlayers: idPlayersString));
      Navigator.pop(context);
    } else {
      _showSnackBar(
          context,
          'Veuillez selectionner des joueurs ou revenir en arrière',
          Colors.orangeAccent);
    }
  }

  void _showSnackBar(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: background,
      ),
    );
  }
}
