import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/bottom_sheet_error.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_selectable_item.dart';
import 'package:flutter_svg/svg.dart';

class GoalBottomSheet extends StatefulWidget {
  final String teamId;
  final int matchId;

  //final Function(int idMatch, int idPlayer, String color) onSubmit;

  GoalBottomSheet({
    Key? key,
    required this.teamId,
    required this.matchId,
  }) : super(key: key);

  @override
  State<GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<GoalBottomSheet> {
  BottomSheetError? errorMessage = null;
  Player? selectedPlayer = null;
  bool opponentGoal = false;

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
                      "Ajouter un but",
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
                "Sélectionner le camps",
                style: TextStyle(
                  color: currentAppColors.secondaryTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      SelectableIcon(
                        onTap: () => {
                          setState(() {
                            opponentGoal = false;
                          })
                        },
                        assetName: "assets/football_icon.svg",
                        assetTint: AppColors.green,
                        isSelected: !opponentGoal,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "CSB",
                        style: TextStyle(
                          color: currentAppColors.secondaryTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      SelectableIcon(
                        onTap: () => {
                          setState(() {
                            opponentGoal = true;
                            if (errorMessage != null) {
                              errorMessage = null;
                            }
                          })
                        },
                        assetName: "assets/football_icon.svg",
                        assetTint: AppColors.red,
                        isSelected: opponentGoal,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ADVERSE",
                        style: TextStyle(
                          color: currentAppColors.secondaryTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: (!opponentGoal) ? null : 0.0,
                  child: (!opponentGoal)
                      ? Column(
                          children: [
                            Text(
                              "Sélectionner un joueur",
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
                              height: 300,
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
                                          child: Text(
                                              "Aucun joueur dans cette équipe."),
                                        );
                                      }
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.players?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final player = state.players![index];
                                          return PlayerSelectableItem(
                                            player: player,
                                            isSelected: player.id ==
                                                this.selectedPlayer?.id,
                                            onTap: () => onPlayerTap(player),
                                          );
                                        },
                                      );
                                    default:
                                      return const Center(
                                        child: Text(
                                            "Aucun joueur dans cette équipe."),
                                      );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  void onPlayerTap(Player player) {
    setState(() {
      this.selectedPlayer = player;
      if (errorMessage != null && errorMessage is NoPlayerSelectedError) {
        errorMessage = null;
      }
    });
  }

  void onValidateTap(BuildContext context) {
    if (!opponentGoal && selectedPlayer == null) {
      setState(() {
        errorMessage =
            NoPlayerSelectedError(message: "Vous devez sélectionner un joueur");
      });
      return;
    }

    // create goal
    final bloc = BlocProvider.of<FmiBloc>(context);
    bloc.add(AddGoal(idMatch: widget.matchId, idPlayer: opponentGoal ? null : selectedPlayer!.id));
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
