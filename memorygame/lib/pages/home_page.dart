import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/game_board.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.memory),
          title: Text('Jogo da Memória NBA'),
        ),
        body: GameBoard());
  }
}
