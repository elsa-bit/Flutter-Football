import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/widgets/loader.dart';

class LoadingDialog {
  //to show our dialog
  static Future<void> show(
      BuildContext context,
      ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Loader();
      },
    );
  }

  // to hide our current dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}