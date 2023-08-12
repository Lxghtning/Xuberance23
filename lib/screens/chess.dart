import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import 'games.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  ChessBoardController controller = ChessBoardController();

  @override
  void initState(){
    super.initState();
    controller.addListener(() {
      if(controller.isCheckMate()) {
        print("CHECKMATE BABY");
      } else if(controller.isDraw()) {
        print("DRAW BABY");
      } else if(controller.isStaleMate()) {
        print("STALEMATE BABY");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: ListView(scrollDirection: Axis.vertical, children: [
        Column( //Main board
          children: [
            const SizedBox(height: 25.0,),
            Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.green,
                boardOrientation: PlayerColor.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => const Games()),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                size: 40.0,
              ),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () => controller.resetBoard(),
              child: const Icon(
                Icons.refresh,
                size: 40.0,
              ),
            ),
          ],
        ),
        Card(
          color: Colors.lightBlue[100],
          child: Column( //display of moves
            children: [
              const Text(
                'Moves: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 30,
                ),
              ),
              ValueListenableBuilder<Chess>(
                valueListenable: controller,
                builder: (context, game, _) {
                  return Text(
                    controller.getSan().fold(
                      '',
                          (previousValue, element) =>
                      '$previousValue\n${element ?? ''}',
                    ),
                    style: const TextStyle(
                      fontSize: 16.9,
                      fontStyle: FontStyle.normal,
                      decorationStyle: TextDecorationStyle.dotted,
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ]),
    );
  }
}
