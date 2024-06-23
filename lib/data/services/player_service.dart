import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/player_min.dart';

abstract class PlayerService {
  Future<String> getPlayersTeam(String idteam);

  Future<Player> getPlayerDetails(int idplayer);

  Future<String> addFriend(String idplayer, String idfriend);

  Future<String> getFriendsPlayer(String idplayer);

  Future<String> modifyPlayer(PlayerMin player, int idPlayer);

  Future<String> getCoachPlayer(String idteam);
}
