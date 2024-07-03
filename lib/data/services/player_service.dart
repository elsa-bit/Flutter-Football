import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/player_min.dart';

abstract class PlayerService {
  Future<String> getPlayersTeam(String idteam);

  Future<Player> getPlayerDetails(String idplayer);

  Future<String> addFriend(String idplayer, String idfriend);

  Future<String> getFriendsPlayer(String idplayer);

  Future<String> modifyPlayer(PlayerMin player, String idPlayer);

  Future<String> getCoachPlayer(String idteam);

  Stream<Player> subscribeToPlayer();

  Future<Player> getNewTrophy(String oldDate, String idplayer);
}
