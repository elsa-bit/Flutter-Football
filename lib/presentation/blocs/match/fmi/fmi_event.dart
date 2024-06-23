abstract class FmiEvent {}

class InitFMI extends FmiEvent {
  final Match match;
  InitFMI({required this.match});
}