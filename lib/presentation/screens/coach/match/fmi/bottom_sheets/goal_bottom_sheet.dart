import 'package:flutter/material.dart';

class GoalBottomSheet extends StatelessWidget {

  const GoalBottomSheet({
    Key? key,
  }) : super(key: key);

  // to close bottom sheet => Navigator.pop(context)
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Goal Modal BottomSheet'),
          ElevatedButton(
            child: const Text('Close BottomSheet'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
