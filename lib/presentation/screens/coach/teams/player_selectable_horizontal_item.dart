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

class PlayerSelectableHorizontalItem extends StatefulWidget {
  final Player player;
  final VoidCallback? onTap;
  final bool isSelected;

  const PlayerSelectableHorizontalItem({
    Key? key,
    required this.player,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  State<PlayerSelectableHorizontalItem> createState() => _PlayerHorizontalItemState();
}

class _PlayerHorizontalItemState extends State<PlayerSelectableHorizontalItem> {
  String? avatarUrl = null;
  late final String identifier;

  @override
  void initState() {
    super.initState();
    identifier = "${widget.player.id.toString()}${widget.player.firstname}";
    BlocProvider.of<MediaBloc>(context)
        .add(GetAvatar(imageName: widget.player.avatar, identifier: identifier));
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
          width: 270,
          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
            color: currentAppColors.primaryVariantColor1,
            border: Border.all(
              width: 2,
              color: widget.isSelected ? currentAppColors.secondaryColor : currentAppColors.primaryVariantColor2,
            ),
            borderRadius: BorderRadius.circular(8),
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
                  Spacer(),
                  Text(
                    "${widget.player.firstname} ${widget.player.lastname}",
                    style: TextStyle(
                      color: currentAppColors.primaryTextColor,
                    ),
                  ),
                  if (widget.player.position != null) ...[
                    Text(
                      "${widget.player.position}".capitalize(),
                      style: AppTextStyle.small
                          .copyWith(color: currentAppColors.secondaryTextColor),
                    ),
                  ] else
                    ...[],
                  Spacer(),
                ],
              ),
              Spacer(),

              if(widget.isSelected)
                SvgPicture.asset(
                  "assets/ic_check.svg",
                  colorFilter: ColorFilter.mode(
                      currentAppColors.secondaryColor, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
