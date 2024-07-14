import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/match_gallery_bottom_sheet.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FmiConsultScreen extends StatefulWidget {
  static const String routeName = 'fmi-consult';
  final MatchDetails match;

  static Route route(MatchDetails match, {bool readOnly = false}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) =>
          FmiConsultScreen(
            match: match,
          ),
    );
  }

  const FmiConsultScreen({Key? key, required this.match})
      : super(key: key);

  @override
  State<FmiConsultScreen> createState() => _FmiConsultScreenState();
}

class _FmiConsultScreenState extends State<FmiConsultScreen> {

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
      body: SafeArea(
        child: BlocBuilder<FmiBloc, FmiState>(
          builder: (mainContext, state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.match.nameTeam,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.end, // Aligns text to the start within the Expanded widget
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.match.opponentName,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.start, // Aligns text to the end within the Expanded widget
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.match.getMatchStateColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: (state.status == FmiStatus.loadingHistory)
                            ? CircularProgressIndicator(
                          color: currentAppColors.primaryTextColor,
                        )
                            : Text(
                          "${state.match?.teamGoals ?? 0} - ${state.match
                              ?.opponentGoals ?? 0}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                            color:
                            currentAppColors.primaryTextColor,
                          ),
                        ),
                      ),

                      if(widget.match.getMatchState() != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            "${widget.match.getMatchState()}".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color:
                              widget.match.getMatchStateColor()?.withOpacity(1),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
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
                    decoration: BoxDecoration(
                      color: currentAppColors.greyColor,
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.image_outlined, color: Colors.white,),
                        Text(
                          "Ressources photo",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Historique des actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: (state.actions == null)
                      ? Center(child: Text("Aucun historique"))
                      : Container(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state.actions!.length,
                      itemBuilder: (context, index) {
                        final action = state.actions![index];
                        return FmiFullHistoryItem(
                          action: action,
                        );
                      },
                    ),
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

class FmiFullHistoryItem extends StatelessWidget {
  final MatchAction action;

  const FmiFullHistoryItem({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                Container(
                  width: 40,
                  child: Text(
                    action.matchTime,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: currentAppColors.primaryTextColor,
                    ),
                  ),
                ),

                SizedBox(width: 10,),

                SvgPicture.asset(
                  action.assetName,
                  colorFilter: (action.assetTint != null)
                      ? ColorFilter.mode(action.assetTint!, BlendMode.srcIn)
                      : null,
                  width: 40,
                ),

                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: action.getActionHistoryWidget(),
                ),

              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
