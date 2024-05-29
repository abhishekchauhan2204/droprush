import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';

class ScoreDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Total Score: ${controller.scores.reduce((a, b) => a + b)}',
                style: TextStyle(fontSize: 24, color: Colors.amber),
              ),
              SizedBox(height: 8),
              Text(
                'Current Ball: ${controller.currentBall + 1}',
                style: TextStyle(fontSize: 18, color: Colors.amber),
              ),
            ],
          ),
        );
      },
    );
  }
}

