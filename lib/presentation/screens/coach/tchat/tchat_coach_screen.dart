import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_event.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_state.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/coach/tchat/conversation_item_coach.dart';
import 'package:flutter_football/presentation/screens/coach/tchat/message_coach_screen.dart';
import 'package:flutter_football/presentation/widgets/csb_search_bar.dart';

class TchatCoachScreen extends StatefulWidget {
  static const String routeName = '/coach/tchat';

  const TchatCoachScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TchatCoachScreen(),
    );
  }

  @override
  State<TchatCoachScreen> createState() => _TchatCoachScreenState();
}

class _TchatCoachScreenState extends State<TchatCoachScreen> {
  final List<Map<String, String>> _playersTeam = [];
  List<String> selectedPlayers = [];
  bool playerListLoading = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context)
      ..add(GetConversationCoach())
      ..add(SubscribeToConversation(mode: 'coach'));

    BlocProvider.of<PlayersBloc>(context).add(GetPlayersTeams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
              "Conversations",
              style: TextStyle(color: AppColors.white),
            )),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAlertDialogToAddConversation(context),
        child: Icon(Icons.add),
      ),
      body: BlocListener<PlayersBloc, PlayersState>(
        listener: (context, state) {
          setState(() {
            if (state.status == PlayersStatus.loading) {
              playerListLoading = true;
            } else {
              playerListLoading = false;
            }
          });
          if (state.status == PlayersStatus.success) {
            _updatePlayersTeam(state.playerSearch!);
          } else if (state.status == PlayersStatus.error) {
            _showSnackBar(context, state.error, Colors.orangeAccent, Icons.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                switch (state.status) {
                  case ConversationStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConversationStatus.error:
                    return Center(
                      child: Text(
                        state.error,
                      ),
                    );
                  case ConversationStatus.success:
                  default:
                    if (state.conversations!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucune conversation, créer en une dès maintenant !",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.conversations!.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations![index];
                        return ConversationItem(
                          conversation: conversation,
                          onTap: () =>
                              _onConversationTap(context, conversation.id),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onConversationTap(BuildContext context, int idConversation) async {
    MessageCoachScreen.navigateTo(context, idConversation.toString());
  }

  Future<void> _displayAlertDialogToAddConversation(
      BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          final searchController = TextEditingController();
          return BlocProvider.value(
            value: BlocProvider.of<ConversationBloc>(context),
            child: BlocConsumer<ConversationBloc, ConversationState>(
              listener: (context, state) {
                if (state.status == ConversationStatus.addSuccess) {
                  _showSnackBar(
                      context, 'Conversation ajoutée', Colors.greenAccent, Icons.check_circle);
                  Navigator.pop(context);
                } else if (state.status == ConversationStatus.addError) {
                  _showSnackBar(context, state.error, Colors.orangeAccent, Icons.error);
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case ConversationStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: const Text(
                          "Qui voulez-vous ajouter dans la conversation ?",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        content: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: CsbSearchBar(
                                    hint: "Rechercher par nom et/ou prénom",
                                    controller: searchController,
                                    onChanged: (v) {
                                      BlocProvider.of<PlayersBloc>(context).add(Search(search: v));
                                    },
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: (playerListLoading) ? [SizedBox(height: 30,), Text("Récupération des joueurs...", textAlign: TextAlign.center,)] : (_playersTeam.isEmpty) ? [SizedBox(height: 30,), Text("Aucun joueur trouvé")] : _playersTeam.map((player) {
                                    return CheckboxListTile(
                                      activeColor: currentAppColors.secondaryColor,
                                      title: Text(player['name']!),
                                      value: selectedPlayers.contains(player['id']),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedPlayers.add(player['id']!);
                                          } else {
                                            selectedPlayers.remove(player['id']!);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    AppColors.lightBlue),
                              ),
                              onPressed: () => _onAddConversation(context),
                              child: Text("Enregistrer"))
                        ],
                      );
                    });
                }
              },
            ),
          );
        });

    BlocProvider.of<PlayersBloc>(context).add(Search(search: ""));
  }

  void _showSnackBar(
      BuildContext context, String text, Color background, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: background,
      ),
    );
  }

  void _updatePlayersTeam(List<Player> players) {
    setState(() {
      _playersTeam.clear();
      for (var player in players) {
        _playersTeam.add({
          'id': player.id,
          'name': "${player.firstname} ${player.lastname}",
        });
      }
    });
  }

  void _onAddConversation(BuildContext context) async {
    var bloc = BlocProvider.of<ConversationBloc>(context);

    if (selectedPlayers.length > 0) {
      bloc.add(AddConversation(players: selectedPlayers.join(",")));
    } else {
      Flushbar(
        message: "Veuillez cocher au moins un joueur",
        messageColor: Colors.black,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        backgroundGradient:
            LinearGradient(colors: [Colors.orangeAccent, Colors.white]),
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }
}
