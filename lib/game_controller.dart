import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameController with ChangeNotifier {
  List<Offset> pegs = [];
  List<Offset> ballPositions = List.generate(20, (_) => Offset(0.5, -0.1)); // Start from a bit higher
  List<int> scores = List.generate(20, (_) => 0);
  int currentBall = 0;
  double ballVelocityY = 0.01;
  double ballVelocityX = 0;
  bool gameOver = false;
  Timer? _timer;

  final double pegRadius = 0.025; // Radius of the peg
  final double ballRadius = 0.05; // Radius of the ball

  List<double> minXPerRow = [];
  List<double> maxXPerRow = [];

  GameController() {
    _initPegs();
  }

  void _initPegs() {
    pegs.clear();
    double rowSpacing = 0.1;  // Vertical distance between rows
    double pegSpacing = 0.1;  // Horizontal distance between pegs

    for (int row = 0; row < 10; row++) {
      int numPegs = row + 2;  // Starting with 2 pegs in the first row, increasing by 1 each row
      double rowYOffset = row * rowSpacing;
      double startingX = 0.5 - (numPegs - 1) * pegSpacing / 2;  // Centering the pegs

      for (int col = 0; col < numPegs; col++) {
        double x = startingX + col * pegSpacing;
        pegs.add(Offset(x, rowYOffset));
      }

      // Store the boundaries for each row
      minXPerRow.add(startingX);
      maxXPerRow.add(startingX + (numPegs - 1) * pegSpacing);
    }
  }

  void resetGame() {
    ballPositions = List.generate(20, (_) => Offset(0.5, -0.1)); // Start from a bit higher
    scores = List.generate(20, (_) => 0);
    currentBall = 0;
    ballVelocityY = 0.01;
    ballVelocityX = 0;
    gameOver = false;
    _timer?.cancel();
    notifyListeners();
  }

  void startDrop() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (gameOver) {
        timer.cancel();
        return;
      }

      // Simulate ball dropping
      ballPositions[currentBall] = Offset(
        ballPositions[currentBall].dx + ballVelocityX,
        ballPositions[currentBall].dy + ballVelocityY,
      );
      ballVelocityY += 0.001; // Gravity effect

      // Check for collisions with pegs
      for (var peg in pegs) {
        if ((ballPositions[currentBall] - peg).distance < (pegRadius + ballRadius)) {
          // Reflect the ball's horizontal velocity when hitting a peg
          ballVelocityX = Random().nextDouble() * 0.2 - 0.1; // Random small horizontal velocity
          ballVelocityY = 0.01; // Ensure the ball keeps falling downward
        }
      }

      // Ensure ball remains within horizontal bounds based on the outermost pegs for the current row
      int currentRow = (ballPositions[currentBall].dy / 0.1).floor();
      if (currentRow < minXPerRow.length) {

        double minX = minXPerRow[currentRow] - ballRadius;
        double maxX = maxXPerRow[currentRow] + ballRadius;

        if (ballPositions[currentBall].dx < minX) {
          ballPositions[currentBall] = Offset(minX, ballPositions[currentBall].dy);
          ballVelocityX = -ballVelocityX; // Reverse direction
        } else if (ballPositions[currentBall].dx > maxX) {
          ballPositions[currentBall] = Offset(maxX, ballPositions[currentBall].dy);
          ballVelocityX = -ballVelocityX; // Reverse direction
        }
      }

      // Check if ball has reached the bottom
      if (ballPositions[currentBall].dy > 1) {
        scores[currentBall] = calculateScore(ballPositions[currentBall]);
        if (currentBall < 19) {
          currentBall++;
          ballVelocityY = 0.01;
          ballVelocityX = 0;
        } else {
          gameOver = true;
        }
        notifyListeners();
        if (gameOver) timer.cancel();
      }
      notifyListeners();
    });
  }

  void dropBall() {
    if (!gameOver) {
      startDrop();
    }
  }

  int calculateScore(Offset position) {
    // Placeholder logic to calculate score based on final ball position
    return (position.dx * 100).toInt();
  }
}
