import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDialog {
  //to show our dialog
  static Future<void> show(
    BuildContext context,
    String message, {
    String? title,
    String? assetName,
    bool? repeat,
    VoidCallback? onValidateAction,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: (title != null) ? Center(child: Text(title)) : null,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (assetName != null)
                Column(
                  children: [
                    Lottie.asset(assetName, width: 130, height: 130, repeat: repeat),
                  ],
                ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 18
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
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
