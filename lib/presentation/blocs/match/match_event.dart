
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