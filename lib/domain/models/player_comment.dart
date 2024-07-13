
class PlayerComment {
  final String idPlayer;
  String comment;

  PlayerComment(this.idPlayer, this.comment);

  Map<String, dynamic> toJson(){
    return {
      "idPlayer": this.idPlayer,
      "comment": this.comment,
    };
  }
}