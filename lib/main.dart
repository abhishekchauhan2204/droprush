import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';
import 'game_board.dart';
import 'score_display.dart';
import 'control_buttons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        title: 'Ball Drop Game',
        theme: ThemeData.dark(),
        home: Scaffold(
          
          body: SafeArea(
            child: Column(
              children: [ ScoreDisplay(),
                ControlButtons(),
                Expanded(child:
                GameBoard()),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
