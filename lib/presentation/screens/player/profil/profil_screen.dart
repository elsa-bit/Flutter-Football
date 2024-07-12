import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/player_min.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/dialogs/confirmation_dialog.dart';
import 'package:flutter_football/presentation/screens/player/profil/infoClub_screen.dart';
import 'package:flutter_football/presentation/screens/player/profil/news_screen.dart';
import 'package:flutter_football/presentation/screens/player/profil/resource_screen.dart';
import 'package:flutter_football/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:flutter_football/utils/extensions/user_extension.dart';
import 'package:intl/intl.dart';

class ProfilScreen extends StatefulWidget {
  static const String routeName = '/player/profil';

  const ProfilScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ProfilScreen(),
    );
  }

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String? avatarUrl;
  late String identifier;
  final SharedPreferencesDataSource sharedPreference =
      SharedPreferencesDataSource();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthBloc>(context).state.user;
    identifier = "${user?.id}${user?.getFirstname()}";
    BlocProvider.of<MediaBloc>(context).add(GetAvatar(identifier: identifier));

    BlocProvider.of<PlayersBloc>(context)
      ..add(GetPlayerDetails())
      ..add(SubscribeToPlayer());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaBloc, MediaState>(
      listener: (context, state) {
        switch (state.status) {
          case MediaStatus.success:
            if (state.response?.identifier == identifier) {
              setState(() {
                avatarUrl = state.response?.url;
              });
            }
            break;
          case MediaStatus.error:
            avatarUrl = state.error;
            break;
          case MediaStatus.profileUpdated:
            BlocProvider.of<MediaBloc>(context)
                .add(GetAvatar(identifier: identifier));
            break;
          default:
            break;
        }
      },
      child: BlocBuilder<PlayersBloc, PlayersState>(
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
            case PlayersStatus.modifySuccess:
            case PlayersStatus.success:
              if (state.detailsPlayer == null) {
                return const Center(
                  child: Text("Ce joueur n'existe pas"),
                );
              }
              return Column(
                children: [
                  Container(
                    height: 350,
                    child: Stack(
                      children: [
                        if (avatarUrl != null) ...[
                          Image.network(
                            avatarUrl!,
                            height: 300,
                            width: MediaQuery.sizeOf(context).width,
                            fit: BoxFit.cover,
                          )
                        ] else ...[
                          Container(
                            height: 300,
                            color: currentAppColors.secondaryTextColor,
                          ),
                        ],
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 30.0),
                            child: ElevatedButton(
                              onPressed: () =>
                                  _displayAlertDialogToModifyPlayer(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              height: 100,
                              width: 250,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Spacer(flex: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${state.detailsPlayer?.firstname} ${state.detailsPlayer?.lastname}",
                                        style: AppTextStyle.subtitle2.copyWith(
                                            color:
                                                currentAppColors.secondaryColor,
                                            fontSize: 20.0),
                                      ),
                                      SizedBox(width: 15.0),
                                      Icon(
                                        Icons.emoji_events,
                                        color: Colors.yellow,
                                        size: 20.0,
                                      ),
                                      Text(
                                        state.detailsPlayer!.trophy.toString(),
                                        style: TextStyle(
                                          color:
                                              currentAppColors.secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    state.detailsPlayer!.email,
                                    style: AppTextStyle.regular.copyWith(
                                        color: currentAppColors.secondaryColor,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Spacer(flex: 2),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Column(
                      children: [
                        OutlinedButton.icon(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                                AppColors.lightBlue),
                            side: WidgetStateProperty.all<BorderSide>(
                                BorderSide(width: 0.2, color: Colors.grey)),
                          ),
                          onPressed: () => _navigateToNewsScreen(context),
                          label: Text(
                            "Actualités du club",
                          ),
                          icon: Icon(Icons.feed, size: 18),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: OutlinedButton.icon(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.lightBlue),
                              side: WidgetStateProperty.all<BorderSide>(
                                  BorderSide(width: 0.2, color: Colors.grey)),
                            ),
                            onPressed: () => _navigateToInfoClubScreen(context),
                            label: Text(
                              "Contact et réglement du club",
                            ),
                            icon: Icon(Icons.contact_mail, size: 18),
                          ),
                        ),
                        OutlinedButton.icon(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                                AppColors.lightBlue),
                            side: WidgetStateProperty.all<BorderSide>(
                                BorderSide(width: 0.2, color: Colors.grey)),
                          ),
                          onPressed: () => _navigateToResourceScreen(context),
                          label: Text(
                            "Ressources entrainement",
                          ),
                          icon: Icon(Icons.directions_run, size: 18),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      ConfirmationDialog.show(
                          context, "Déconnexion", "Annuler", "Déconnexion",
                          description: "Es-tu sûr de vouloir te deconnecter ?",
                          onCancelAction: () {}, onValidateAction: () {
                        final authBloc = BlocProvider.of<AuthBloc>(context);
                        authBloc
                          ..add(Logout(mode: 'player'))
                          ..add(AuthLogout());

                        /*final scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
                          final playersBloc = BlocProvider.of<PlayersBloc>(context);
                          final mediaBloc = BlocProvider.of<MediaBloc>(context);
                          final fmiBloc = BlocProvider.of<FmiBloc>(context);
                          final teamsBloc = BlocProvider.of<TeamsBloc>(context);
                          final conversationBloc = BlocProvider.of<ConversationBloc>(context);
                          final messageBloc = BlocProvider.of<MessageBloc>(context);
                          authBloc.add(ClearAuthStates());
                          scheduleBloc.add(ClearScheduleStates());
                          playersBloc.add(ClearPlayerState());
                          mediaBloc.add(ClearMediaState());
                          fmiBloc.add(ClearFMIState());
                          teamsBloc.add(ClearTeamsState());
                          conversationBloc.add(ClearConversationState());
                          messageBloc.add(ClearMessageState());*/
                      }, validateActionTint: Colors.red);
                    },
                    child: Text(
                      "Déconnexion",
                      style: AppTextStyle.subtitle1.copyWith(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              );
            default:
              return const Center(
                child: Text("Ce joueur n'existe pas"),
              );
          }
        },
      ),
    );
  }

  Future<void> _displayAlertDialogToModifyPlayer(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: BlocProvider.of<PlayersBloc>(context),
            child: BlocConsumer<PlayersBloc, PlayersState>(
              listener: (context, state) {
                if (state.status == PlayersStatus.modifySuccess) {
                  _showSnackBar(
                      context, 'Joueur modifié !', Colors.greenAccent);
                  _passwordController.clear();
                  _positionController.clear();
                  _birthdayController.clear();
                  Navigator.pop(context);
                } else if (state.status == PlayersStatus.error) {
                  _showSnackBar(context, state.error, Colors.orangeAccent);
                  _passwordController.clear();
                  _positionController.clear();
                  _birthdayController.clear();
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case PlayersStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PlayersStatus.success:
                  default:
                    _positionController.text =
                        state.detailsPlayer?.position ?? '';
                    _birthdayController.text = DateFormat('dd-MM-yyyy').format(
                        DateTime.parse(state.detailsPlayer?.birthday ?? ''));

                    return StatefulBuilder(builder: (mainContext, setState) {
                      return AlertDialog(
                        title: const Text("Modifier mon profil"),
                        content: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(mainContext).viewInsets.bottom),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: "Position"),
                                  controller: _positionController,
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Mot de passe (si change)"),
                                  controller: _passwordController,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                                SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: mainContext,
                                      initialDate: DateTime.parse(
                                          state.detailsPlayer!.birthday!),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _birthdayController.text =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _birthdayController,
                                      decoration: InputDecoration(
                                          labelText: "Date de naissance *"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: mainContext,
                                      builder: (BuildContext context) {
                                        return ImagePickerBottomSheet(
                                          onImagePicked: (file) {
                                            BlocProvider.of<MediaBloc>(
                                                    mainContext)
                                                .add(
                                                    UpdateProfilePicture(file));
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color:
                                              currentAppColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          AppColors.lightBlue)),
                              onPressed: () => _onModifyPlayer(mainContext),
                              child: Text("Enregistrer"))
                        ],
                      );
                    });
                }
              },
            ),
          );
        });
  }

  void _onModifyPlayer(BuildContext context) async {
    var bloc = BlocProvider.of<PlayersBloc>(context);
    late PlayerMin player;

    if (_passwordController.text != '') {
      player = PlayerMin(
          position: _positionController.text,
          password: _passwordController.text,
          birthday: _birthdayController.text);
    } else {
      player = PlayerMin(
          position: _positionController.text,
          birthday: _birthdayController.text);
    }
    bloc.add(ModifyPlayer(player: player));
  }

  void _showSnackBar(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: background,
      ),
    );
  }

  void _navigateToNewsScreen(BuildContext context) {
    NewsScreen.navigateTo(context);
  }

  void _navigateToInfoClubScreen(BuildContext context) {
    InfoClubScreen.navigateTo(context);
  }

  void _navigateToResourceScreen(BuildContext context) {
    ResourceScreen.navigateTo(context);
  }
}
