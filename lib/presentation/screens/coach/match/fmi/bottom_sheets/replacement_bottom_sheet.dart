import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/fmi/bottom_sheet_error.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_selectable_horizontal_item.dart';
import 'package:flutter_svg/svg.dart';

class ReplacementBottomSheet extends StatefulWidget {
  final String teamId;
  final int matchId;

  ReplacementBottomSheet({
    Key? key,
    required this.teamId,
    required this.matchId,
  }) : super(key: key);

  @override
  State<ReplacementBottomSheet> createState() => _ReplacementBottomSheetState();
}

class _ReplacementBottomSheetState extends State<ReplacementBottomSheet> {
  BottomSheetError? errorMessage = null;
  Player? selectedPlayerOut = null;
  Player? selectedPlayerIn = null;
  final commentController = TextEditingController();


  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context)
        .add(GetPlayersTeam(teamId: widget.teamId));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: currentAppColors.primaryVariantColor1,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Text(
                        "Annuler",
                        style: TextStyle(
                          color: currentAppColors.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Remplacement",
                      style: TextStyle(
                        color: currentAppColors.primaryTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => {onValidateTap(context)},
                      child: Text(
                        "Valider",
                        style: TextStyle(
                          color: currentAppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null) ...[
                SizedBox(
                  height: 30,
                ),
                Text(
                  errorMessage!.message,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],

              SizedBox(
                height: 30,
              ),
              Text(
                "Commentaire (Optionnel)",
                style: TextStyle(
                  color: currentAppColors.secondaryTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    hintText: "Blessure, comportement, etc.",
                    hintStyle: AppTextStyle.small,
                    filled: true,
                    fillColor: currentAppColors.primaryVariantColor1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  controller: commentController,
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 4,
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Text(
                "Joueur sortant",
                style: TextStyle(
                  color: currentAppColors.secondaryTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: BlocBuilder<PlayersBloc, PlayersState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case PlayersStatus.loading:
                        return Text("Chargement des joueurs...");
                      case PlayersStatus.error:
                        return Text(state.error);
                      case PlayersStatus.success:
                        if (state.players!.isEmpty) {
                          return const Center(
                            child: Text("Aucun joueur dans cette équipe."),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.players?.length ?? 0,
                          itemBuilder: (context, index) {
                            final player = state.players![index];
                            return PlayerSelectableHorizontalItem(
                              player: player,
                              isSelected:
                                  player.id == this.selectedPlayerOut?.id,
                              onTap: () => onPlayerOutTap(player),
                            );
                          },
                        );
                      default:
                        return const Center(
                          child: Text("Aucun joueur dans cette équipe."),
                        );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Joueur entrant",
                style: TextStyle(
                  color: currentAppColors.secondaryTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: BlocBuilder<PlayersBloc, PlayersState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case PlayersStatus.loading:
                        return Text("Chargement des joueurs...");
                      case PlayersStatus.error:
                        return Text(state.error);
                      case PlayersStatus.success:
                        if (state.players!.isEmpty) {
                          return const Center(
                            child: Text("Aucun joueur dans cette équipe."),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.players?.length ?? 0,
                          itemBuilder: (context, index) {
                            final player = state.players![index];
                            return PlayerSelectableHorizontalItem(
                              player: player,
                              isSelected:
                                  player.id == this.selectedPlayerIn?.id,
                              onTap: () => onPlayerInTap(player),
                            );
                          },
                        );
                      default:
                        return const Center(
                          child: Text("Aucun joueur dans cette équipe."),
                        );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      );
    });
  }

  void onPlayerOutTap(Player player) {
    setState(() {
      if (this.selectedPlayerIn?.id == player.id) {
        errorMessage = NoPlayerSelectedError(message: "Vous devez remplacer le joueur par un autre joueur.");
        return;
      }
      this.selectedPlayerOut = player;
      if (errorMessage != null && errorMessage is NoPlayerSelectedError) {
        errorMessage = null;
      }
    });
  }

  void onPlayerInTap(Player player) {
    setState(() {
      if (this.selectedPlayerOut?.id == player.id) {
        errorMessage = NoPlayerSelectedError(message: "Vous devez remplacer le joueur par un autre joueur.");
        return;
      }
      this.selectedPlayerIn = player;
      if (errorMessage != null && errorMessage is NoPlayerSelectedError) {
        errorMessage = null;
      }
    });
  }

  void onValidateTap(BuildContext context) {
    if (selectedPlayerOut == null || selectedPlayerIn == null) {
      setState(() {
        errorMessage =
            NoPlayerSelectedError(message: "Vous devez sélectionner un joueur");
      });
      return;
    }

    // create goal
    final bloc = BlocProvider.of<FmiBloc>(context);
    bloc.add(AddReplacement(
        idMatch: widget.matchId,
        idPlayerOut: selectedPlayerOut!.id,
        idPlayerIn: selectedPlayerIn!.id,
        reason: commentController.text));
    Navigator.pop(context);
  }
}

class SelectableIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String assetName;
  final bool isSelected;
  final Color? assetTint;

  const SelectableIcon({
    Key? key,
    required this.onTap,
    required this.assetName,
    required this.isSelected,
    this.assetTint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: currentAppColors.primaryVariantColor1,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(
            width: 4,
            color: isSelected
                ? currentAppColors.secondaryColor
                : currentAppColors.primaryVariantColor2,
          ),
        ),
        child: SvgPicture.asset(
          assetName,
          width: 50,
          height: 50,
          colorFilter: (assetTint != null)
              ? ColorFilter.mode(assetTint!, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}
