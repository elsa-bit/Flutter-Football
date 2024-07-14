import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/cards_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/goal_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/match_gallery_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/replacement_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/report/report_screen.dart';
import 'package:flutter_football/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:flutter_football/utils/image_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FmiScreen extends StatefulWidget {
  static const String routeName = 'fmi';
  final MatchDetails match;
  final bool readOnly;

  static Route route(MatchDetails match, {bool readOnly = false}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => FmiScreen(
        match: match,
        readOnly: readOnly,
      ),
    );
  }

  const FmiScreen({Key? key, required this.match, this.readOnly = false})
      : super(key: key);

  @override
  State<FmiScreen> createState() => _FmiScreenState();
}

class _FmiScreenState extends State<FmiScreen> {
  bool historyIsVisible = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FmiBloc>(context).add(InitFMI(match: widget.match));
    BlocProvider.of<MediaBloc>(context)
        .add(GetMatchBucketImages(matchId: widget.match.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "FMI",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: currentAppColors.secondaryColor,
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MatchBloc, MatchState>(
            listener: (context, state) {
              switch (state.status) {
                case MatchStatus.refresh:
                  break;
                default:
                  break;
              }
            },
          ),
          BlocListener<FmiBloc, FmiState>(
            listener: (context, state) {
              switch (state.status) {
                case FmiStatus.successCard:
                  _showSuccessSnackBar(context, "Carton ajouté à l'historique");
                  BlocProvider.of<FmiBloc>(context).add(ResetSuccessFMIState());
                  break;
                case FmiStatus.successReplacement:
                  _showSuccessSnackBar(
                      context, "Remplacement ajouté à l'historique");
                  BlocProvider.of<FmiBloc>(context).add(ResetSuccessFMIState());
                  break;
                case FmiStatus.successGoal:
                  _showSuccessSnackBar(context, "But ajouté à l'historique");
                  BlocProvider.of<FmiBloc>(context).add(ResetSuccessFMIState());
                  break;
                case FmiStatus.errorCard:
                  _showErrorSnackBar(
                      context, "Le carton n'a pas pu être ajouté");
                  BlocProvider.of<FmiBloc>(context).add(ResetErrorFMIState());
                  break;
                case FmiStatus.errorReplacement:
                  _showErrorSnackBar(
                      context, "Le remplacement n'a pas pu être ajouté");
                  BlocProvider.of<FmiBloc>(context).add(ResetErrorFMIState());
                  break;
                case FmiStatus.errorGoal:
                  _showErrorSnackBar(context, "Le but n'a pas pu être ajouté");
                  BlocProvider.of<FmiBloc>(context).add(ResetErrorFMIState());
                  break;
                default:
                  break;
              }
            },
          ),
        ],
        child: SafeArea(
          child: BlocBuilder<FmiBloc, FmiState>(
            builder: (mainContext, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            /*Row(
                            children: [
                              Text(
                                "${state.match?.nameTeam}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  color: currentAppColors.primaryTextColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "VS",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30,
                                  color: currentAppColors.primaryTextColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${state.match?.opponentName}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  color: currentAppColors.primaryTextColor,
                                ),
                              ),
                            ],
                          ),*/
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: (state.status == FmiStatus.loadingHistory)
                                  ? CircularProgressIndicator(
                                      color: currentAppColors.primaryTextColor,
                                    )
                                  : Text(
                                      "${state.match?.teamGoals ?? 0} - ${state.match?.opponentGoals ?? 0}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30,
                                        color:
                                            currentAppColors.primaryTextColor,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FmiAction(
                                  onTap: () async {
                                    if (DateTime.now().isAfter(widget.match.date.add(Duration(minutes: 135)))) {
                                      _showMatchEndedSnackBar(context);
                                    } else if (!widget.readOnly) {
                                      await showModalBottomSheet(
                                        context: mainContext,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return GoalBottomSheet(
                                            teamId: widget.match.idTeam,
                                            matchId: widget.match.id,
                                          );
                                        },
                                      );
                                      BlocProvider.of<FmiBloc>(context)
                                          .add(Search(search: ""));
                                    }
                                  },
                                  color: currentAppColors.secondaryColor,
                                  imageAsset: "assets/football_icon.svg",
                                  title: "But",
                                ),
                                FmiAction(
                                  onTap: () async {
                                    if (DateTime.now().isAfter(widget.match.date.add(Duration(minutes: 135)))) {
                                      _showMatchEndedSnackBar(context);
                                    } else if (!widget.readOnly) {
                                      await showModalBottomSheet(
                                        context: mainContext,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return ReplacementBottomSheet(
                                            teamId: widget.match.idTeam,
                                            matchId: widget.match.id,
                                          );
                                        },
                                      );
                                      BlocProvider.of<FmiBloc>(context)
                                          .add(Search(search: ""));
                                    }
                                  },
                                  color: currentAppColors.secondaryColor,
                                  imageAsset: "assets/replacement_icon.svg",
                                  title: "Remplacement",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FmiAction(
                                  onTap: () async {
                                    if (DateTime.now().isAfter(widget.match.date.add(Duration(minutes: 135)))) {
                                      _showMatchEndedSnackBar(context);
                                    } else if (!widget.readOnly) {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: mainContext,
                                        builder: (BuildContext context) {
                                          return CardsBottomSheet(
                                            teamId: widget.match.idTeam,
                                            matchId: widget.match.id,
                                          );
                                        },
                                      );
                                      BlocProvider.of<FmiBloc>(context)
                                          .add(Search(search: ""));
                                    }
                                  },
                                  color: currentAppColors.secondaryColor,
                                  imageAsset: "assets/cards_icon.svg",
                                  title: "Faute",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: mainContext,
                                          builder: (BuildContext context) {
                                            return MatchGalleryBottomSheet(
                                                matchId:
                                                    widget.match.id.toString());
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          color: currentAppColors.greyColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ressources photo",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () {
                                        if (!widget.readOnly) {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: mainContext,
                                            builder: (BuildContext context) {
                                              return ImagePickerBottomSheet(
                                                onImagePicked: (file) {
                                                  uploadImageToSupabase(
                                                      file, mainContext);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: currentAppColors.greyColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                if (!widget.readOnly)
                                  GestureDetector(
                                    onTap: () {
                                      //ConfirmationDialog.show(context, , cancelAction, {});
                                      Navigator.push(mainContext,
                                          ReportScreen.route(widget.match));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.darkGreen,
                                            AppColors.green,
                                          ],
                                        ),
                                        color: AppColors.darkGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Valider la FMI",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        color: currentAppColors.primaryColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  historyIsVisible = !historyIsVisible;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: currentAppColors.primaryVariantColor1,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Historique",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            currentAppColors.primaryTextColor,
                                      ),
                                    ),
                                    if (state.status ==
                                        FmiStatus.loadingHistory)
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color:
                                              currentAppColors.primaryTextColor,
                                        ),
                                      ),
                                    if (state.status !=
                                        FmiStatus.loadingHistory)
                                      Icon(
                                        historyIsVisible
                                            ? Icons.keyboard_arrow_down_rounded
                                            : Icons.keyboard_arrow_up_rounded,
                                        color:
                                            currentAppColors.primaryTextColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: (historyIsVisible &&
                                      (state.actions != null &&
                                          state.actions!.isNotEmpty))
                                  ? null
                                  : 0.0,
                              child: (historyIsVisible &&
                                      (state.actions != null &&
                                          state.actions!.isNotEmpty))
                                  ? FmiHistory(actions: state.actions!)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> uploadImageToSupabase(
      File file, BuildContext mainContext) async {
    LoadingDialog.show(mainContext);
    try {
      final filename = "${widget.match.id}/${createFileName()}";
      final response =
          await uploadImage(file, matchResourcesBucketName, filename);
      BlocProvider.of<MediaBloc>(mainContext)
          .add(AddImageToMatchBucket(filename));
      LoadingDialog.hide(mainContext);
      _showSuccessSnackBar(mainContext, "Image ajoutée aux ressources");
    } catch (e) {
      LoadingDialog.hide(mainContext);
      String errorMessage =
          "Un erreur est survenue. Cette image n'a pas pu être envoyé au serveur.";
      debugPrint(e.toString());
      _showErrorSnackBar(mainContext, errorMessage);
    }
  }

  void _showSuccessSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.orange,
      ),
    );
  }

  void _showMatchEndedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.access_alarms,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Ce match est terminé",
              style: TextStyle(color: Colors.white),
              maxLines: 2,
            ),
          ],
        ),
        backgroundColor: currentAppColors.greyColor,
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
        width: 115.0,
        height: 115.0,
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
                height: 55,
                width: 55,
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
                    overflow: TextOverflow.ellipsis),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
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
              action.matchTime,
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
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 14),
            child: action.getActionDetailWidget()),
      ],
    );
  }
}
