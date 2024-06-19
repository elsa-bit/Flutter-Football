import 'package:flutter_football/domain/models/player.dart';

abstract class PlayerService {
  Future<String> getPlayersTeam(String idteam);

  Future<Player> getPlayerDetails(int idplayer);

  Future<String> addFriend(String idplayer, String idfriend);
}
