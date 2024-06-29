import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/cards_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/goal_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/replacement_bottom_sheet.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TODO : A chaque insertion Success d'une action dans la BDD, ajouter manuellement les informations et update les states
// TODO : state pour afficher le détail d'une action dans l'historique

/*
  bloclistener
  switch (state.status) {
                case FmiStatus.initial:
                  break;
                case FmiStatus.loading:
                  LoadingDialog.show(context);
                  break;
                case FmiStatus.success:
                  LoadingDialog.hide(context);
                  break;
                case FmiStatus.error:
                  print(state.error);
                  LoadingDialog.hide(context);
                  // TODO : create FMIErrorHandler to handle errors like FMICardCreationException
                  // TODO : rely on login screen
                  //handleError(state.error.toString());
                  break;
              }
   */
class FmiScreen extends StatefulWidget {
  static const String routeName = '/fmi';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => FmiScreen(
        match: match,
      ),
    );
  }

  const FmiScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<FmiScreen> createState() => _FmiScreenState();
}

class _FmiScreenState extends State<FmiScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FmiBloc>(context).add(InitFMI(match: widget.match));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FMI"),
      ),
      body: SafeArea(
        child: BlocBuilder<FmiBloc, FmiState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "${widget.match.teamGoals} - ${widget.match.opponentGoals}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: currentAppColors.primaryTextColor,
                    ),
                  ),
                ),
                Container(
                  //margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          FmiAction(
                            onTap: () => {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return GoalBottomSheet();
                                },
                              )
                            },
                            color: AppColors.mediumBlue,
                            imageAsset: "assets/football_icon.svg",
                            title: "But",
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          FmiAction(
                            onTap: () => {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return CardsBottomSheet(
                                    teamId: widget.match.idTeam,
                                    matchId: widget.match.id,
                                  );
                                },
                              )
                            },
                            color: AppColors.mediumBlue,
                            imageAsset: "assets/cards_icon.svg",
                            title: "Faute",
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          FmiAction(
                            onTap: () => {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return ReplacementBottomSheet();
                                },
                              )
                            },
                            color: AppColors.mediumBlue,
                            imageAsset: "assets/replacement_icon.svg",
                            title: "Remplacement",
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          FmiAction(
                            onTap: () => {},
                            color: AppColors.mediumBlue,
                            imageAsset: "assets/cards_icon.svg",
                            title: "Faute",
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: (state.actions != null && state.actions!.isNotEmpty) ? null : 0.0,
                    child: (state.actions != null && state.actions!.isNotEmpty)
                        ? FmiHistory(actions: state.actions!)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FmiAction extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final String imageAsset;
  final String title;

  const FmiAction({
    Key? key,
    required this.onTap,
    required this.color,
    required this.imageAsset,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageAsset,
                height: 80,
                width: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FmiHistory extends StatefulWidget {
  final List<MatchAction> actions;

  const FmiHistory({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  State<FmiHistory> createState() => _FmiHistoryState();
}

class _FmiHistoryState extends State<FmiHistory> {
  MatchAction? actionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text(
            "Historique",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: currentAppColors.primaryTextColor,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.actions.length,
              itemBuilder: (context, index) {
                final action = widget.actions[index];
                return FmiHistoryItem(
                  action: action,
                  isSelected: action.id == actionSelected?.id,
                  onTap: () => {this.onActionTap(action)},
                );
              },
            ),
          ),
          if (this.actionSelected != null)
            FmiActionDetails(action: this.actionSelected!),
        ],
      ),
    );
  }

  void onActionTap(MatchAction action) {
    setState(() {
      this.actionSelected =
          (action.id != this.actionSelected?.id) ? action : null;
    });
  }
}

class FmiHistoryItem extends StatelessWidget {
  final MatchAction action;
  final VoidCallback? onTap;
  final bool isSelected;

  const FmiHistoryItem({
    Key? key,
    required this.action,
    this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: currentAppColors.primaryVariantColor1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 2,
                    color: isSelected
                        ? currentAppColors.secondaryColor
                        : Colors.transparent),
              ),
              child: SvgPicture.asset(
                action.assetName,
                colorFilter: (action.assetTint != null)
                    ? ColorFilter.mode(action.assetTint!, BlendMode.srcIn)
                    : null,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              action.createdAt.formatTime(),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: currentAppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FmiActionDetails extends StatelessWidget {
  final MatchAction action;

  const FmiActionDetails({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: currentAppColors.primaryVariantColor1,
          thickness: 2,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: action.getActionDetailWidget()),
      ],
    );
  }
}
