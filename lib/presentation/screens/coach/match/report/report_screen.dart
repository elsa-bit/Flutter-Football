import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/player_comment.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/dialogs/confirmation_dialog.dart';
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
  late PageController _pageController;
  int _currentPage = 0;
  List<PlayerComment> playerComments = [];
  late ValueNotifier<Player?> _playerSelected;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<FmiBloc>();
    _pageController = PageController(initialPage: _currentPage);
    _playerSelected = ValueNotifier(bloc.state.playersPlayedMatch?.first);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      // assuming there are 3 pages
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Rapport général",
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: currentAppColors.secondaryColor,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Stack(
                            children: [
                              Align(
                                child: Image.asset(
                                  "assets/images/baseStade.png",
                                  height: 400,
                                ),
                                alignment: Alignment.center,
                              ),
                              Align(
                                child: BlocBuilder<FmiBloc, FmiState>(
                                  builder: (context, state) {
                                    print(state.playersPlayedMatch?.length ??
                                        "no playersPlayedMatch");
                                    return Container(
                                      width: 200,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: List.generate(
                                            state.playersPlayedMatch?.length ??
                                                0, (index) {
                                          final player =
                                              state.playersPlayedMatch![index];
                                          return PlayerIcon(
                                            player: player,
                                            isSelected:
                                                _playerSelected.value?.id ==
                                                    player.id,
                                            onTap: () {
                                              setState(() {
                                                _playerSelected.value = player;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            alignment: Alignment.center,
                          ),
                        ),
                        /*Container(
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
                        ),*/
                        // Player comment
                        if (_playerSelected.value != null)
                          ValueListenableBuilder<Player?>(
                            valueListenable: _playerSelected,
                            builder: (context, p, _) {
                              final commentController = TextEditingController();
                              final i = playerComments
                                  .indexWhere((e) => e.idPlayer == p!.id);
                              if (i > -1)
                                commentController.text =
                                    playerComments[i].comment;

                              return Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                margin: const EdgeInsets.only(
                                    bottom: 8, left: 15, right: 15, top: 30),
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
                                        color: currentAppColors
                                            .primaryVariantColor2,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/football_icon.svg',
                                            height: 20,
                                            width: 20,
                                            colorFilter: ColorFilter.mode(
                                                currentAppColors
                                                    .secondaryTextColor,
                                                BlendMode.srcIn),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            (p!.number == 0)
                                                ? "${p.fullName()}"
                                                : "${p.number} ${p.fullName()}",
                                            style: TextStyle(
                                                color: currentAppColors
                                                    .primaryTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextField(
                                      onTapOutside: (e) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
                                      decoration: InputDecoration(
                                        hintText:
                                            "Ajouter un commentaire sur ce joueur",
                                        hintStyle: AppTextStyle.small,
                                        filled: true,
                                        fillColor: currentAppColors
                                            .primaryVariantColor1,
                                        border: InputBorder.none,
                                      ),
                                      controller: commentController,
                                      enableSuggestions: false,
                                      autocorrect: true,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color:
                                            currentAppColors.primaryTextColor,
                                        fontSize: 14,
                                      ),
                                      onChanged: (s) {
                                        if (p == null) return;
                                        final commentIndex =
                                            playerComments.indexWhere(
                                                (c) => c.idPlayer == p.id);
                                        if (commentIndex == -1) {
                                          playerComments
                                              .add(PlayerComment(p.id, s));
                                        } else {
                                          // comment already created
                                          if (s.isEmpty) {
                                            playerComments
                                                .removeAt(commentIndex);
                                          } else {
                                            playerComments[commentIndex]
                                                .comment = s;
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                    color:
                                        currentAppColors.primaryVariantColor2,
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
                                            color: currentAppColors
                                                .primaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  onTapOutside: (e) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Ajouter un commentaire sur le match",
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
                                    color:
                                        currentAppColors.primaryVariantColor2,
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
                                            color: currentAppColors
                                                .primaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  onTapOutside: (e) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if ((_currentPage > 0))
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(
                            currentAppColors.primaryTextColor),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(currentAppColors.greyColor),
                      ),
                      onPressed: _previousPage,
                      icon: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: AppColors.white,
                      ),
                      label: Text(
                        "Précédent",
                        style: TextStyle(
                            color: AppColors.white),
                      ),
                    )
                  else
                    Spacer(),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                          currentAppColors.primaryTextColor),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(AppColors.lightBlue),
                    ),
                    onPressed: () {
                      if (_currentPage == 0) {
                        _nextPage();
                      } else {
                        onSavePressed(context);
                      }
                    },
                    icon: (_currentPage == 0)
                        ? Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: AppColors.white,
                          )
                        : null,
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      (_currentPage == 0) ? "Suivant" : "Valider",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed(BuildContext context) {
    ConfirmationDialog.show(context, "Validation FMI", "Annuler", "Valider",
        description:
            "En validant cette action vous sauvegardez les informations de cette FMI.\n\nVous ne pourrez plus la modifer.",
        onValidateAction: () {
      BlocProvider.of<MatchBloc>(context).add(SetFMIReport(
          widget.match.id,
          teamCommentController.text,
          opponentTeamCommentController.text,
          (playerComments.isEmpty) ? null : playerComments));
    });
  }
}

class PlayerIcon extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onTap;

  PlayerIcon({
    Key? key,
    required this.player,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          child: Text(
            (player.number == 0)
                ? "${player.initials()}"
                : player.number.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.mediumBlue,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: isSelected ? AppColors.mediumBlue : Colors.white,
        ),
      ),
    );
  }
}
