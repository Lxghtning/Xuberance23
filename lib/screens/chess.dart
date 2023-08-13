import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import 'dashboard.dart';
import 'games.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  ChessBoardController controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if(controller.isCheckMate()) {
        print("CHECKMATE");
        _showCheckmateDialog();
      }  else if(controller.isStaleMate()) {
        _showStalemateDialog();
      }
    });
  }

  void _showCheckmateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("CHECKMATE"),
          content: Text("The game is over!"),
          actions: <Widget>[
            ElevatedButton(onPressed: (){
              controller.resetBoard();
              Navigator.of(context).pop();
            }, child: Text("Play again?")),
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showStalemateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Draw By Stalemate"),
          content: Text("The game is over!"),
          actions: <Widget>[
            ElevatedButton(onPressed: (){
              controller.resetBoard();
              Navigator.of(context).pop();
            }, child: Text("Play again?")),
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard()),
                );
              },
            ),
          ],
        );
      },
    );
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
