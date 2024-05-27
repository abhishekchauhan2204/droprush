import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<GameController>().resetGame();
            },
            child: Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!context.read<GameController>().gameOver) {
                context.read<GameController>().dropBall();
              }
            },
            child: Text('Drop Ball'),
          ),
        ],
      ),
    );
  }
}
