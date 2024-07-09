import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/dialogs/confirmation_dialog.dart';
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
    BlocProvider.of<MediaBloc>(context)
        .add(GetAvatar(identifier: identifier));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaBloc, MediaState>(
      listener: (context, state) {
        switch (state.status) {
          case MediaStatus.success:
            if(state.response?.identifier == identifier) {
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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (mainContext, state) {
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
                        width:  MediaQuery.sizeOf(mainContext).width,
                        fit: BoxFit.cover,
                      )
                    ] else
                      ...[
                        Container(
                          height: 300,
                          color: currentAppColors.secondaryTextColor,
                        ),
                      ],
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: mainContext,
                              builder: (BuildContext context) {
                                return ImagePickerBottomSheet(
                                  onImagePicked: (file) {
                                    BlocProvider.of<MediaBloc>(mainContext).add(UpdateProfilePicture(file));
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: Icon(Icons.edit, color: Colors.white,),
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
                              Text(
                                "${state.user?.getFirstname() ?? " "} ${state
                                    .user?.getLastname() ?? ""}",
                                style: AppTextStyle.subtitle2.copyWith(
                                    color: currentAppColors.secondaryColor),
                              ),
                              Spacer(),
                              Text(
                                state.user?.getRole() ?? "",
                                style: AppTextStyle.regular.copyWith(
                                    color: currentAppColors.secondaryColor),
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
              ElevatedButton(
                onPressed: () {
                  ConfirmationDialog.show(
                      mainContext,
                      "Déconnexion",
                      "Annuler",
                      "Déconnexion",
                      description: "Es-tu sûr de vouloir te deconnecter ?",
                      onCancelAction: (){},
                      onValidateAction: (){
                        final authBloc = BlocProvider.of<AuthBloc>(mainContext);
                        authBloc.add(Logout());

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
                      },
                      validateActionTint: Colors.red
                  );
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
        },
      ),
    );
  }
}
