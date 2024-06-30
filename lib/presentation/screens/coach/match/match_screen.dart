import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/data/data_sources/match_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/match_bloc.dart';
import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/fmi_screen.dart';
import 'package:flutter_football/presentation/screens/coach/match/match_item.dart';
import 'package:flutter_football/presentation/widgets/loader.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchScreen extends StatelessWidget {
  static const String routeName = '/match';

  const MatchScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MatchScreen(),
    );
  }

  // TODO :
  //  - retrieve matchs of teams (preferences)
  //  - retrieve names of teams
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchBloc(
        repository: RepositoryProvider.of<MatchRepository>(context),
      )..add(GetMatches()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: BlocBuilder<MatchBloc, MatchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case MatchStatus.loading:
                      return Loader();
                    case MatchStatus.error:
                      return Text(state.error);
                    case MatchStatus.success:
                      return Column(
                        children: [
                          if (state.previousMatch != null &&
                              state.previousMatch!.isNotEmpty)
                            Expanded(child: MatchSection(title: "Matchs passés", matches: state.previousMatch!)),
                          if (state.nextMatch != null &&
                              state.nextMatch!.isNotEmpty)
                            Expanded(child: MatchSection(title: "Matchs à venir", matches: state.nextMatch!)),
                        ],
                      );

                    default:
                      return Center(
                        child: Text("Aucun match pour le moment"),
                      );
                  }
                },
              ),
            ),
          );
        }
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
        Text(
            title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
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
    if(match.win != null || match.date.isEqualOrBefore(DateTime.now())) {
      if(!match.FMICompleted) {
        // Create / Edit FMI
        Navigator.push(
            context,
            FmiScreen.route(match)
        );
      } else {
        // TODO : Read FMI
      }

    }
  }
}
