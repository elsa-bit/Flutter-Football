import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';
import 'package:flutter_svg/svg.dart';

class PlayerItem extends StatefulWidget {
  final Player player;
  final VoidCallback? onTap;


  //final avatarFile = File('path/to/file');

  const PlayerItem({
    Key? key,
    required this.player,
    this.onTap,
  }) : super(key: key);

  @override
  State<PlayerItem> createState() => _PlayerItemState();
}

class _PlayerItemState extends State<PlayerItem> {
  String? avatarUrl = null;
  late final String identifier;

  @override
  void initState() {
    super.initState();
    identifier = "${widget.player.id.toString()}${widget.player.firstname}";
    BlocProvider.of<MediaBloc>(context)
        .add(GetUserAvatar(identifier: identifier, userID: widget.player.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaBloc, MediaState>(
      listener: (context, state) {
        switch (state.status) {
          case MediaStatus.success:
            if(state.response?.identifier == identifier) {
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 15.0),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
            color: currentAppColors.primaryVariantColor1,
            border: Border.all(color: currentAppColors.primaryVariantColor2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              if (avatarUrl != null) ...[
                Image.network(
                  avatarUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              ] else
                ...[],
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.player.firstname} ${widget.player.lastname}",
                    style: TextStyle(
                      color: currentAppColors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.player.position != null && widget.player.position!.isNotEmpty) ...[
                    Text(
                      "${widget.player.position}".capitalize(),
                      style: AppTextStyle.small
                          .copyWith(color: currentAppColors.secondaryTextColor),
                    ),
                  ] else
                    ...[],
                ],
              ),
              Spacer(),
              SvgPicture.asset(
                "assets/arrow.svg",
                colorFilter: ColorFilter.mode(
                    currentAppColors.secondaryTextColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPlayerPicture() async {
  }
}
