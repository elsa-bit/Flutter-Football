
import 'package:flutter_football/domain/models/match_details.dart';

abstract class MatchEvent {}

class GetMatches extends MatchEvent {
  GetMatches();
}

class GetSelection extends MatchEvent {
  final String idTeam;
  final int idMatch;

  GetSelection(this.idTeam, this.idMatch);
}

class SetFMIReport extends MatchEvent {
  final int idMatch;
  final String? commentTeam;
  final String? commentOpponent;

  SetFMIReport(this.idMatch, this.commentTeam, this.commentOpponent);
}

class SetSelection extends MatchEvent {
  final MatchDetails match;
  final List<String> idPlayers;

  SetSelection(this.match, this.idPlayers);
}

class OnRedirectionDone extends MatchEvent {
  OnRedirectionDone();
}