abstract class FmiEvent {}

class InitFMI extends FmiEvent {
  final Match match;
  InitFMI({required this.match});
}

class AddReplacement extends FmiEvent {
  final int idMatch;
  final int idPlayerOut;
  final int idPlayerIn;
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
  final int? idPlayer; // set idPlayer to null for opponent's goal

  AddGoal({
    required this.idMatch,
    required this.idPlayer,
  });
}


class AddCard extends FmiEvent {
  final int idMatch;
  final int idPlayer;
  final String color;

  AddCard({
    required this.idMatch,
    required this.idPlayer,
    required this.color,
  });
}