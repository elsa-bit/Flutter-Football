import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';

class PlayerSelectionItem extends StatefulWidget {
  final Player player;
  final VoidCallback? onTap;

  const PlayerSelectionItem({
    Key? key,
    required this.player,
    this.onTap,
  }) : super(key: key);

  @override
  State<PlayerSelectionItem> createState() => _PlayerSelectionItemState();
}

class _PlayerSelectionItemState extends State<PlayerSelectionItem> {
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
          alignment: Alignment.centerLeft,
          width: 120,
          height: 100,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
            color: currentAppColors.primaryVariantColor1,
            border: Border.all(color: currentAppColors.primaryVariantColor2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 10,),
                Text(
                  "${widget.player.firstname} ${widget.player.lastname}",
                  style: TextStyle(
                    color: currentAppColors.primaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                if (widget.player.position != null && widget.player.position!.isNotEmpty) ...[
                  Text(
                    "${widget.player.position}".capitalize(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppTextStyle.small
                        .copyWith(color: currentAppColors.secondaryTextColor),
                  ),
                ] else
                  ...[],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getPlayerPicture() async {
  }
}
