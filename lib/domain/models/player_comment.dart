
class PlayerComment {
  final String idPlayer;
  final String namePlayer;
  String comment;

  PlayerComment(this.idPlayer, this.namePlayer, this.comment);

  Map<String, dynamic> toJson(){
    return {
      "namePlayer": this.namePlayer,
      "comment": this.comment,
    };
  }
}