import 'package:flutter/material.dart';

class ErrorDialog {
  //to show our dialog
  static Future<void> show(
      BuildContext context,
      String message,
      {
        VoidCallback? onValidateAction,
      }
      ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Erreur")),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: (){
                onValidateAction?.call();
                hide(context);
              },
              child: Text(
                "OK",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  // to hide our current dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
