import 'package:flutter/material.dart';
import 'package:flutter_snake/flutter_snake.dart';
import 'dart:async';
import 'games.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});
  
  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake>{
  SnakeGame? snakeGame;
  StreamController<GAME_EVENT>? controller;

  @override
  void initState() {
    super.initState();

    controller = StreamController<GAME_EVENT>();
    controller?.stream.listen((GAME_EVENT value) {
      print(value.toString());
    });
    // Example:
    snakeGame = SnakeGame(
      caseWidth: 25.0,
      numberCaseHorizontally: 11,
      numberCaseVertically: 11,
      controllerEvent: controller,
      durationBetweenTicks: const Duration(milliseconds: 400),
      colorBackground1: const Color(0XFF7CFC00),
      colorBackground2: const Color(0XFF32CD32),
    );
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Snake"),
        ),
        body: Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (BuildContext context) => const Snake())
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.refresh,
                        size: 25.0,
                      ),
                    ),
                  ),

                ]
              ),
              const SizedBox(height: 20.0),
              snakeGame ?? const Text("Not initialized"),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.left,
                    icon: const Icon(Icons.arrow_back_outlined, color: Colors.white, size: 50),
                  ),
                  const Padding(
                    padding:  EdgeInsets.fromLTRB(70, 20, 55, 0),
                    child:  Text("SNAKE", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
                  ),
                  IconButton(
                    onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.right,
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white,size: 50),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}