import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/dialogs/error_dialog.dart';
import 'package:flutter_football/presentation/dialogs/loading_dialog.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/fmi_consult_screen.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/fmi_screen.dart';
import 'package:flutter_football/presentation/screens/coach/match/match_item.dart';
import 'package:flutter_football/presentation/screens/coach/match/selection/selection_screen.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchScreen extends StatefulWidget {
  static const String routeName = 'match';

  const MatchScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MatchScreen(),
    );
  }

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MatchBloc>(context).add(GetMatches());
  }

  Future<void> _refresh() async {
    BlocProvider.of<MatchBloc>(context).add(GetMatches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Builder(builder: (context) {
          return BlocListener<MatchBloc, MatchState>(
            listener: (context, state) {
              switch (state.status) {
                case MatchStatus.loading:
                  LoadingDialog.show(context);
                  break;
                case MatchStatus.error:
                  LoadingDialog.hide(context);
                  ErrorDialog.show(context, state.error?.message ?? "Une erreur est survenue...");
                  break;
                case MatchStatus.success:
                  LoadingDialog.hide(context);
                  break;
                case MatchStatus.initial:
                  LoadingDialog.hide(context);
                  break;
                case MatchStatus.refresh:
                  BlocProvider.of<MatchBloc>(context).add(GetMatches());
                  break;
                case MatchStatus.redirect:
                  final redirection = state.redirection;
                  //LoadingDialog.show(context);
                  Future.delayed(Duration(seconds: 2), () {
                    BlocProvider.of<MatchBloc>(context).add(GetMatches());
                    if (redirection != null) {
                      Navigator.push(context, FmiScreen.route(redirection));
                    }
                  });
                  break;
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: BlocBuilder<MatchBloc, MatchState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (state.previousMatch != null &&
                            state.previousMatch!.isNotEmpty)
                          Expanded(
                              child: MatchSection(
                                  title: "Matchs passés",
                                  matches: state.previousMatch!)),
                        if (state.nextMatch != null &&
                            state.nextMatch!.isNotEmpty)
                          Expanded(
                              child: MatchSection(
                                  title: "Matchs à venir",
                                  matches: state.nextMatch!)),
                        if ((state.nextMatch == null ||
                            state.nextMatch!.isEmpty) && (state.previousMatch == null ||
                            state.previousMatch!.isEmpty))
                          Expanded(
                            child: Center(
                              child: Text("Aucun match pour le moment"),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MatchSection extends StatelessWidget {
  final String title;
  final List<MatchDetails> matches;

  const MatchSection({
    Key? key,
    required this.title,
    required this.matches,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top:25, bottom: 20),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return MatchItem(
                match: match,
                onTap: () => this.onMatchTap(context, match),
              );
            },
          ),
        ),
      ],
    );
  }

  void onMatchTap(BuildContext context, MatchDetails match) {
    if (match.win != null || match.date.isEqualOrBefore(DateTime.now())) {
      if (!match.FMICompleted) {
        // Create / Edit FMI
        //Navigator.push(context, FmiScreen.route(match));
        if (match.playerSelection == null) {
          Navigator.push(context, SelectionScreen.route(match));
        } else {
          Navigator.push(context, FmiScreen.route(match));
        }
      } else {
        Navigator.push(context, FmiConsultScreen.route(match));
      }

    }
  }
}
