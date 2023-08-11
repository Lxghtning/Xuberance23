import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'messages.dart';


class Loading extends StatefulWidget {
  final BuildContext context;

  const Loading(this.context, {super.key});

  @override
  State<Loading> createState() => _LoadingState();
}


class _LoadingState extends State<Loading>{

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() async{
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Messages()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.lightBlue,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              color: Colors.white,
              size: 150,
            ),
          ],
        ),
      ),

    );
  }
}
