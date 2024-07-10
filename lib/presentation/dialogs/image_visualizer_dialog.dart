import 'package:flutter/material.dart';

class ImageVisualizerDialog {
  //to show our dialog
  static Future<void> show(
      BuildContext context,
      String imageUrl,
      ) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final double verticalPadding = screenHeight * 0.1;
        final double horizontalPadding = screenWidth * 0.1;
        return Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  // to hide our current dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
