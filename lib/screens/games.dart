import 'package:flutter/material.dart';
import 'package:hackathonxcodexuberance/screens/dashboard.dart';
import 'package:hackathonxcodexuberance/screens/snake.dart';
import 'chess.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'profile.dart';

void main() => runApp(const EntertainmentApp());

class EntertainmentApp extends StatelessWidget {
  const EntertainmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Game(),
    );
  }
}

class Games extends StatelessWidget {
  const Games({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 150, 50,0),
              child: Text(
                "Have fun gaming!",
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  buildGameItem(Icons.games, 'Chess', Colors.red, Colors.redAccent,context),
                  buildGameItem(Icons.trending_down, 'Snake', Colors.blue, Colors.blueAccent,context),

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        currentIndex: 3,
        selectedItemColor: Colors.amber,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if(index == 0){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Friends()),
            );
          }
          else if(index == 1){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Messages()),
            );
          }
          else if(index == 2){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Feed()),
            );
          }else if(index == 3){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Dashboard()),
            );
          }else if(index == 4){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Profile()),
            );
          }
        },
      ),
    );
  }

  Widget buildGameItem(IconData icon, String label, Color color1, Color color2,BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          print(label);
          if(label == 'Chess'){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Game()),
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Snake()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                label,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}