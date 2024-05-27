import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameController with ChangeNotifier {
  List<Offset> pegs = [];
  List<Offset> ballPositions = [];
  List<int> scores = [];
  int currentBall = 0;
  double ballVelocityY = 0;
  double ballVelocityX = 0;
  bool gameOver = false;
  Timer? _timer;

  GameController() {
    _initPegs();
    resetGame();
  }

  void _initPegs() {
    pegs.clear();
    double rowSpacing = 0.1;
    double colSpacing = 0.1;

    for (int row = 0; row < 10; row++) {
      int numPegs = row + 2;  // Starting with 2 pegs in the first row, increasing by 1 each row
      for (int col = 0; col < numPegs; col++) {
        double x = (col + 1) / (numPegs + 1);
        double y = row * rowSpacing;
        pegs.add(Offset(x, y));
      }
    }
  }

  void resetGame() {
    ballPositions = List.generate(20, (_) => Offset(0.5, 0));
    scores = List.generate(20, (_) => 0);
    currentBall = 0;
    ballVelocityY = 0.01;
    ballVelocityX = 0;
    gameOver = false;
    _timer?.cancel();
    notifyListeners();
  }

  void startDrop() {
    if (gameOver) return;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (gameOver) {
        timer.cancel();
        return;
      }

      // Simulate ball dropping
      ballPositions[currentBall] = Offset(
        ballPositions[currentBall].dx,
        ballPositions[currentBall].dy + ballVelocityY,
      );
      ballVelocityY += 0.001; // Gravity effect

      // Check for collisions with pegs
      for (var peg in pegs) {
        if ((ballPositions[currentBall] - peg).distance < 0.05) {
          ballVelocityX = Random().nextDouble() - 0.5;
        }
      }

      ballPositions[currentBall] = Offset(
        ballPositions[currentBall].dx + ballVelocityX,
        ballPositions[currentBall].dy,
      );
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
    if (!gameOver && _timer == null) {
      startDrop();
    }
  }

  int calculateScore(Offset position) {
    // Placeholder logic to calculate score based on final ball position
    return (position.dx * 100).toInt();
  }
}
