import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/dialogs/image_visualizer_dialog.dart';

class MatchGalleryBottomSheet extends StatefulWidget {
  final String matchId;

  MatchGalleryBottomSheet({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  State<MatchGalleryBottomSheet> createState() =>
      _MatchGalleryBottomSheetState();
}

class _MatchGalleryBottomSheetState extends State<MatchGalleryBottomSheet> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: currentAppColors.primaryVariantColor1,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ressources photo",
                style: TextStyle(
                  color: currentAppColors.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<MediaBloc, MediaState>(builder: (context, state) {
            switch (state.status) {
              case MediaStatus.loadingImages:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if((state.images?.length ?? 0) == 0) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Vous n'avez pas encore ajouté de ressource pour ce match.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: currentAppColors.secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 15,
                    children: List.generate(state.images?.length ?? 0, (index) {
                      final imageUrl = state.images![index];
                      return GestureDetector(
                        onTap: () {
                          ImageVisualizerDialog.show(context, imageUrl);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                );
            }
          }),
        ),
      ],
    );
  }
}
