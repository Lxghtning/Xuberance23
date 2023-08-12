import 'package:flutter/material.dart';
import 'games.dart';
import 'genre.dart';
import 'song.dart';
import 'searchVid.dart';
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
      title: 'Entertainment App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
            "Hey there! Whats on your mind today?",
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
                  buildDashboardItem(Icons.tv, 'Videos', Colors.red, Colors.redAccent,context),
                  buildDashboardItem(Icons.music_note, 'Music', Colors.blue, Colors.blueAccent,context),
                  buildDashboardItem(Icons.games, 'Games', Colors.purple, Colors.purpleAccent,context),
                  buildDashboardItem(Icons.book, 'Where\'s my food?', Colors.orange, Colors.orangeAccent,context),

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

  Widget buildDashboardItem(IconData icon, String label, Color color1, Color color2,BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          print(label);
          if(label == 'Videos'){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const SearchVid()),
            );
          } else if(label == 'Music'){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Genre()),
            );
          } else if(label == 'Games'){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Games()),
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
