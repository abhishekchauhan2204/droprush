import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';

class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, child) {
        return CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: GameBoardPainter(controller),
        );
      },
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final GameController controller;
  GameBoardPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    // Draw pegs
    for (var row = 0; row < controller.pegs.length; row++) {
      for (var col = 0; col < controller.pegs[row].length; col++) {
        if (controller.pegs[row][col]) {
          final offset = Offset(
            col * size.width / controller.pegs[row].length,
            row * size.height / controller.pegs.length,
          );
          canvas.drawCircle(offset, 5, paint);
        }
      }
    }

    // Draw balls
    for (var i = 0; i <= controller.currentBall; i++) {
      final ballOffset = Offset(
        controller.ballPositions[i].dx * size.width,
        controller.ballPositions[i].dy * size.height,
      );
      canvas.drawCircle(ballOffset, 10, paint..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
