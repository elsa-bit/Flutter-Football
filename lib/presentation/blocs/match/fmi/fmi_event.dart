import 'package:flutter_football/domain/models/match_details.dart';

abstract class FmiEvent {}

class InitFMI extends FmiEvent {
  final MatchDetails match;
  InitFMI({required this.match});
}

class Search extends FmiEvent {
  final String search;

  Search({
    required this.search,
  });
}

class AddReplacement extends FmiEvent {
  final int idMatch;
  final String idPlayerOut;
  final String idPlayerIn;
  final String? reason;

  AddReplacement({
    required this.idMatch,
    required this.idPlayerOut,
    required this.idPlayerIn,
    required this.reason,
  });
}

class AddGoal extends FmiEvent {
  final int idMatch;
  final String? idPlayer;

  AddGoal({
    required this.idMatch,
    required this.idPlayer,
  });
}


class AddCard extends FmiEvent {
  final int idMatch;
  final String idPlayer;
  final String color;

  AddCard({
    required this.idMatch,
    required this.idPlayer,
    required this.color,
  });
}

class ClearFMIState extends FmiEvent {
  ClearFMIState();
}

class ResetSuccessFMIState extends FmiEvent {
  ResetSuccessFMIState();
}

class ResetErrorFMIState extends FmiEvent {
  ResetErrorFMIState();
}