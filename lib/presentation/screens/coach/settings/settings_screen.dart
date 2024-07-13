import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_bloc.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_event.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_state.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/dialogs/confirmation_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/settings/doc_screen.dart';
import 'package:flutter_football/presentation/screens/coach/settings/rule_screen.dart';
import 'package:flutter_football/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:flutter_football/utils/extensions/user_extension.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SettingsScreen(),
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? avatarUrl;
  late String identifier;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthBloc>(context).state.user;
    identifier = "${user?.id}${user?.getFirstname()}";
    BlocProvider.of<MediaBloc>(context).add(GetAvatar(identifier: identifier));

    BlocProvider.of<CoachBloc>(context).add(GetCoachDetails());
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
            break;
          case MediaStatus.profileUpdated:
            BlocProvider.of<MediaBloc>(context)
                .add(GetAvatar(identifier: identifier));
            break;
          default:
            break;
        }
      },
      child: BlocBuilder<CoachBloc, CoachState>(
        builder: (context, state) {
          switch (state.status) {
            case CoachStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case CoachStatus.error:
              return Center(
                child: Text(
                  state.error,
                ),
              );
            case CoachStatus.success:
              if (state.detailsCoach == null) {
                return const Center(
                  child: Text("Ce coach n'existe pas"),
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
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ImagePickerBottomSheet(
                                      onImagePicked: (file) {
                                        BlocProvider.of<MediaBloc>(context)
                                            .add(UpdateProfilePicture(file));
                                      },
                                    );
                                  },
                                );
                              },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${state.detailsCoach?.firstName} ${state.detailsCoach?.lastName}",
                                    style: AppTextStyle.subtitle2.copyWith(
                                        color: currentAppColors.secondaryColor,
                                        fontSize: 20.0),
                                  ),
                                  Text(
                                    state.detailsCoach!.email,
                                    style: AppTextStyle.regular.copyWith(
                                        color: currentAppColors.secondaryColor,
                                        fontStyle: FontStyle.italic),
                                  ),
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
                          onPressed: () => _navigateToCoachRule(context),
                          label: Text(
                            "Charte des éducateurs",
                          ),
                          icon: Icon(Icons.assignment, size: 18),
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
                            onPressed: () =>
                                _navigateToDocumentClubScreen(context),
                            label: Text(
                              "Documents du club",
                            ),
                            icon: Icon(Icons.description, size: 18),
                          ),
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
                          ..add(Logout(mode: 'coach'))
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
                child: Text("Ce coach n'existe pas"),
              );
          }
        },
      ),
    );
  }

  void _navigateToCoachRule(BuildContext context) {
    RuleScreen.navigateTo(context);
  }

  void _navigateToDocumentClubScreen(BuildContext context) {
    DocScreen.navigateTo(context);
  }
}
