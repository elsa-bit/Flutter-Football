class Event {
  final String? id;
  final String? title;
  final String type;
  final DateTime schedule;
  final String? team;
  final String? idTeam;
  final String? place;
  final String? subject;
  final String? opponentName;
  final List<dynamic>? presence;

  Event(this.id, this.title, this.type, this.schedule, this.team, this.idTeam,
      this.place, this.subject, this.opponentName, this.presence);
}
