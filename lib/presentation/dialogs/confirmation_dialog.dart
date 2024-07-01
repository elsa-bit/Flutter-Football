import 'package:flutter/material.dart';

class ConfirmationDialog {
  //to show our dialog
  static Future<void> show(
    BuildContext context,
    String title,
    String cancelAction,
    String validateAction, {
        String? description,
        VoidCallback? onCancelAction,
        VoidCallback? onValidateAction,
        Color? cancelActionTint,
        Color? validateActionTint,
      }
  ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: (description != null) ? Text(description) : null,
          actions: [
            ElevatedButton(
              onPressed: (){
                onCancelAction?.call();
                hide(context);
              },
              child: Text(
                cancelAction,
                style: TextStyle(color: cancelActionTint),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                onValidateAction?.call();
                hide(context);
              },
              child: Text(
                validateAction,
                style: TextStyle(color: validateActionTint),
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
