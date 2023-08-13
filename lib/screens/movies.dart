import 'package:flutter/material.dart';
import '../Firebase/database.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'profile.dart';

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {

  String searchQuery = "thriller";

  final Database _firestoreDatabase = Database();

  List genreList = [];

  @override
  void initState() {
    super.initState();
    load().then((result) {
      setState(() {});
    });
  }


  Future<void> load() async {
    print(genreList);
    genreList = await _firestoreDatabase.sendDetailsGenre(searchQuery);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                onChanged: (value){
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter Genre for Movies",
                  prefixIcon:  IconButton(icon: Icon(Icons.search),
                    onPressed: () async{
                      genreList = await _firestoreDatabase.sendDetailsGenre(searchQuery);
                    }),
                  prefixIconColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 20,),
              const Text("New Movies", style: TextStyle(fontSize: 20, color: Colors.white),),
              const SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: genreList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Inbox()),
                                );
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    genreList[index],
                                    style: const TextStyle(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ]),
              ),
              const SizedBox(height: 20),
              Text("Suggestions for: $searchQuery", style: const TextStyle(fontSize: 20, color: Colors.white),),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i = 0; i<4; i++)
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: SizedBox(
                            height: 300,
                            width: 200,
                            child: Image.network(
                              genreList[i],
                              fit: BoxFit.cover,
                            ),
                          )
                      )
                  ],
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
}
