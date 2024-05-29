import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';

class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: GameBoardPainter(controller, constraints),
            );
          },
        );
      },
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final GameController controller;
  final BoxConstraints constraints;

  GameBoardPainter(this.controller, this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    // Draw pegs
    for (var peg in controller.pegs) {
      final offset = Offset(
        peg.dx * size.width,
        peg.dy * size.height,
      );
      canvas.drawCircle(offset, 5, paint);
    }

    // Draw balls
    for (var i = 0; i <= controller.currentBall; i++) {
      final ballOffset = Offset(
        controller.ballPositions[i].dx * size.width,
        controller.ballPositions[i].dy * size.height,
      );
      canvas.drawCircle(ballOffset, 8, paint..color = Colors.amber);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
