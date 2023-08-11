import 'package:flutter/material.dart';
import '../Firebase/auth.dart';
import '../Firebase/database.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';

final Database _firestoreDatabase = Database();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  String name = '';
  String email = '';
  String gender = '';

  final AuthService _auth = AuthService();

  Map<String, dynamic> currentUserDetails = {};

  @override
  void initState(){
    super.initState();
    load().then((result){
      setState(() {

      });
    });
  }

  Future<void> load() async{
    currentUserDetails = await _firestoreDatabase.sendCurrentUserDetails();
    name = currentUserDetails['name'];
    email = currentUserDetails['email'];
    gender = currentUserDetails['gender'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(350, 10, 0, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () async{
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/pfp.jpeg'),
                  radius: 50.0,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 37.5, 0, 0),
                child: Container(
                  width: 500,
                  height: 567,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 50, 300, 0),
                        child: Text(
                          "Username",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 250, 0),
                        child: Text(
                          name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 50, 330, 0),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
                        child: Text(
                          email,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 50, 300, 0),
                        child: Text(
                          "Friend Count",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 300, 0),
                        child: Text(
                          currentUserDetails['friendCount'].toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 50, 330, 0),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 335, 0),
                        child: Text(
                          gender,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  builder: (BuildContext context) => Messages()),
            );
          }
          else if(index == 2){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Feed()),
            );
          }
        },
      ),
    );
  }

}
