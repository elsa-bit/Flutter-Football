class Event {
  final String? title;
  final String type;
  final DateTime schedule;
  final String? team;
  final String? place;
  final String? subject;
  final String? opponentName;

  Event(this.title, this.type, this.schedule, this.team, this.place,
      this.subject, this.opponentName);
}
