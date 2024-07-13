import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PlayerProfileScreen extends StatefulWidget {
  static const String routeName = '/playerProfile';
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});

  static Route route(Player player) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => PlayerProfileScreen(
        player: player,
      ),
    );
  }

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  String? avatarUrl = null;
  late final String identifier;

  @override
  void initState() {
    super.initState();
    identifier = "${widget.player.id.toString()}${widget.player.firstname}";
    BlocProvider.of<MediaBloc>(context).add(GetUserAvatar(
        identifier: identifier, userID: widget.player.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaBloc, MediaState>(
      listener: (context, state) {
        switch (state.status) {
          case MediaStatus.success:
            if (state.response?.identifier == identifier) {
              setState(() {
                avatarUrl = state.response?.url;
              });
            }
            break;
          case MediaStatus.error:
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text("${widget.player.firstname} ${widget.player.lastname}",
              style: TextStyle(color: AppColors.white)),
          backgroundColor: currentAppColors.secondaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (avatarUrl != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            avatarUrl!,
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ] else
                      ...[],
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white, //Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      PlayerStatItem(
                          name: "Date de naissance",
                          value: _formatDate(widget.player.birthday!)),
                      PlayerStatItem(
                          name: "Position",
                          value: (widget.player.position?.isNotEmpty == true)
                              ? widget.player.position!.toString().capitalize()
                              : "_"),
                      PlayerStatItem(
                          name: "Licence",
                          value: widget.player.num_licence?.toString() ?? "_"),
                      PlayerStatItem(
                          name: "Matchs joués",
                          value: widget.player.matchPlayed.toString()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sports_soccer,
                                color: currentAppColors.secondaryColor,
                                size: 35.0,
                              ),
                              SizedBox(width: 18.0),
                              Text(
                                '${widget.player.goal} Buts',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.change_circle,
                                  color: currentAppColors.secondaryColor,
                                  size: 35.0,
                                ),
                                SizedBox(width: 18.0),
                                Text(
                                  '${widget.player.replacement} Changement',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/yellow_card.svg',
                                  semanticsLabel: 'Yellow Card',
                                  height: 30,
                                  width: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 23.0),
                                  child: Text(
                                    '${widget.player.yellowCard} Jaune',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/red_card.svg',
                                semanticsLabel: 'Red Card',
                                height: 30,
                                width: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Text(
                                  '${widget.player.yellowCard} Rouge',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }
}

class PlayerStatItem extends StatelessWidget {
  final String name;
  final String value;

  const PlayerStatItem({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
