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
import 'package:flutter_football/presentation/widgets/csb_search_bar.dart';
import 'package:flutter_svg/svg.dart';

class CSBCard {
  final String assetName;
  final String value;
  bool isSelected;

  CSBCard({
    required this.assetName,
    required this.value,
    required this.isSelected,
  });
}

class CardsBottomSheet extends StatefulWidget {
  final String teamId;
  final int matchId;
  //final Function(int idMatch, int idPlayer, String color) onSubmit;

  CardsBottomSheet({
    Key? key,
    required this.teamId,
    required this.matchId,
  }) : super(key: key);

  @override
  State<CardsBottomSheet> createState() => _CardsBottomSheetState();
}

class _CardsBottomSheetState extends State<CardsBottomSheet> {
  final List<CSBCard> cards = [
    CSBCard(assetName: "assets/yellow_card.svg", value: "yellow", isSelected: false),
    CSBCard(assetName: "assets/red_card.svg", value: "red", isSelected: false),
  ];
  BottomSheetError? errorMessage = null;
  Player? selectedPlayer = null;
  final searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context)
        .add(GetPlayersTeam(teamId: widget.teamId));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
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
                        "Signaler une faute",
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
                  "Sélectionner un carton",
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
                    SelectableIcon(
                      onTap: () => {
                        setState(() {
                          cards[0].isSelected = true;
                          cards[1].isSelected = false;
                          if (errorMessage != null &&
                              errorMessage is NoCardSelectedError) {
                            errorMessage = null;
                          }
                        })
                      },
                      assetName: cards[0].assetName,
                      isSelected: cards[0].isSelected,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SelectableIcon(
                      onTap: () => {
                        setState(() {
                          cards[1].isSelected = true;
                          cards[0].isSelected = false;
                          if (errorMessage != null &&
                              errorMessage is NoCardSelectedError) {
                            errorMessage = null;
                          }
                        })
                      },
                      assetName: cards[1].assetName,
                      isSelected: cards[1].isSelected,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: CsbSearchBar(
                    hint: "Rechercher par nom et/ou prénom",
                    controller: searchController,
                    onChanged: (v) {
                      BlocProvider.of<PlayersBloc>(context).add(Search(search: v));
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 260,
                  child: BlocBuilder<PlayersBloc, PlayersState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case PlayersStatus.loading:
                          return Text("Chargement des joueurs...");
                        case PlayersStatus.error:
                          return Text(state.error);
                        case PlayersStatus.success:
                          if (state.playerSearch!.isEmpty) {
                            return const Center(
                              child: Text("Aucun joueur dans cette équipe."),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.playerSearch?.length ?? 0,
                            itemBuilder: (context, index) {
                              final player = state.playerSearch![index];
                              return PlayerSelectableItem(
                                player: player,
                                isSelected: player.id == this.selectedPlayer?.id,
                                onTap: () => onPlayerTap(player),
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
              ],
            ),
          ],
        );
      }
    );
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
    final CSBCard? selectedCard = getSelectedCard();
    if (selectedCard == null) {
      setState(() {
        errorMessage =
            NoCardSelectedError(message: "Vous devez sélectionner un carton");
      });
      return;
    }

    if (selectedPlayer == null) {
      setState(() {
        errorMessage =
            NoPlayerSelectedError(message: "Vous devez sélectionner un joueur");
      });
      return;
    }

    // create card
    final bloc = BlocProvider.of<FmiBloc>(context);
    bloc.add(AddCard(idMatch: widget.matchId, idPlayer: selectedPlayer!.id, color: selectedCard.value));
    Navigator.pop(context);
  }

  CSBCard? getSelectedCard() {
    try {
      return cards.firstWhere((e) => e.isSelected, orElse: null);
    } catch (e) {
      return null;
    }
  }
}

class SelectableIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String assetName;
  final bool isSelected;

  const SelectableIcon({
    Key? key,
    required this.onTap,
    required this.assetName,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: currentAppColors.primaryVariantColor1,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              width: 4,
              color: isSelected
                  ? currentAppColors.secondaryColor
                  : currentAppColors.primaryVariantColor2,),
        ),
        child: SvgPicture.asset(
          assetName,
          width: 50,
          height: 57,
        ),
      ),
    );
  }
}
