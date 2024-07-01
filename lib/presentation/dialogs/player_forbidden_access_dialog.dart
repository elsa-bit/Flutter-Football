import 'package:flutter/material.dart';

class PlayerForbiddenAccessDialog {
  static Future<void> show(
      BuildContext context,) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Votre accès a été restreint !", textAlign: TextAlign.center,)),
          content: Text("Pour plus de details sur la cause, contacter un responsable", textAlign: TextAlign.center,),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: (){
                  hide(context);
                },
                child: Text(
                  "J'ai compris",
                ),
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
