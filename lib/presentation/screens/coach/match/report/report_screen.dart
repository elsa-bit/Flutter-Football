import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/dialogs/confirmation_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/match/match_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportScreen extends StatefulWidget {
  static const String routeName = 'report';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ReportScreen(
        match: match,
      ),
    );
  }

  const ReportScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final teamCommentController = TextEditingController();
  final opponentTeamCommentController = TextEditingController();
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchBloc, MatchState>(
      listener: (context, state) {
        switch (state.status) {
          case MatchStatus.refresh:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Rapport général"),
        ),
        body: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(children: [
                      Image.asset(
                        "assets/images/baseStade.png",
                      ),
                    ]),
                    Container(
                      //padding: const EdgeInsets.symmetric(vertical: 15),
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          //final match = matches[index];
                          return Center(child: Text("Element $index"));
                        },
                      ),
                    ),
                    // Player comment
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      margin: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: currentAppColors.primaryVariantColor1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: currentAppColors.primaryVariantColor2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/football_icon.svg',
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                      currentAppColors.secondaryTextColor,
                                      BlendMode.srcIn),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.match.opponentName,
                                  style: TextStyle(
                                      color:
                                      currentAppColors.primaryTextColor),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            onTapOutside: (e) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              hintText:
                              "Ajouter un commentaire sur l'équipe adverse",
                              hintStyle: AppTextStyle.small,
                              filled: true,
                              fillColor:
                              currentAppColors.primaryVariantColor1,
                              border: InputBorder.none,
                            ),
                            controller: opponentTeamCommentController,
                            enableSuggestions: false,
                            autocorrect: true,
                            maxLines: 3,
                            style: TextStyle(
                              color: currentAppColors.primaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Page for comments
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: currentAppColors.primaryVariantColor1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: currentAppColors.primaryVariantColor2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/football_icon.svg',
                                    height: 20,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                        currentAppColors.secondaryTextColor,
                                        BlendMode.srcIn),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "CS Brétigny - ${widget.match.nameTeam}",
                                    style: TextStyle(
                                        color:
                                            currentAppColors.primaryTextColor),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              onTapOutside: (e) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: InputDecoration(
                                hintText: "Ajouter un commentaire sur le match",
                                hintStyle: AppTextStyle.small,
                                filled: true,
                                fillColor:
                                    currentAppColors.primaryVariantColor1,
                                border: InputBorder.none,
                              ),
                              controller: teamCommentController,
                              enableSuggestions: false,
                              autocorrect: true,
                              maxLines: 10,
                              style: TextStyle(
                                color: currentAppColors.primaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: currentAppColors.primaryVariantColor1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: currentAppColors.primaryVariantColor2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/football_icon.svg',
                                    height: 20,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                        currentAppColors.secondaryTextColor,
                                        BlendMode.srcIn),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.match.opponentName,
                                    style: TextStyle(
                                        color:
                                            currentAppColors.primaryTextColor),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              onTapOutside: (e) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: InputDecoration(
                                hintText:
                                    "Ajouter un commentaire sur l'équipe adverse",
                                hintStyle: AppTextStyle.small,
                                filled: true,
                                fillColor:
                                    currentAppColors.primaryVariantColor1,
                                border: InputBorder.none,
                              ),
                              controller: opponentTeamCommentController,
                              enableSuggestions: false,
                              autocorrect: true,
                              maxLines: 5,
                              style: TextStyle(
                                color: currentAppColors.primaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                              currentAppColors.primaryTextColor),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              AppColors.lightBlue),
                        ),
                        onPressed: () {
                          onSavePressed(context);
                        },
                        child: Text("Sauvegarder"),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void onSavePressed(BuildContext context) {
    ConfirmationDialog.show(context, "Validation FMI", "Annuler", "Valider",
        description:
            "En validant cette action vous sauvegardez les informations de cette FMI.\n\nVous ne pourrez plus la modifer.",
        onValidateAction: () {
      BlocProvider.of<MatchBloc>(context).add(SetFMIReport(widget.match.id,
          teamCommentController.text, opponentTeamCommentController.text));
    });
  }
}
