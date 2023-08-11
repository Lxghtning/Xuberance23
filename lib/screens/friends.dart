import 'package:flutter/material.dart';
import 'feed.dart';
import 'messages.dart';
import 'profile.dart';
import '../Firebase/database.dart';

final Database _firestoreDatabase = Database();

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  TextEditingController controller = TextEditingController();


  List userList = [];
  List friendReqNameList = [];
  List friendsNameList = [];
  List searchFilteredList = [];
  List userDisplayList = [];
  List friendsNameDisplayList = [];

  @override
  void initState(){
    super.initState();
    load().then((result) {
      setState((){

      });
    });
  }

  Future<void> load() async{
    userList = await _firestoreDatabase.sendUsers();
    friendReqNameList = await _firestoreDatabase.sendFriendRequestNameList();
    friendsNameList = await _firestoreDatabase.sendFriendsNameList();
    userDisplayList = userList;
    friendsNameDisplayList = friendsNameList;
  }

  void updateUsersList(String query){
    setState(() {
      userDisplayList = userList.where((users) => users.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void updateFriendsNameList(String query){
    setState(() {
      friendsNameDisplayList = friendsNameList.where((users) => users.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person_search_rounded)),
                Tab(icon: Icon(Icons.person_add_alt_rounded)),
                Tab(icon: Icon(Icons.people)),
              ],
            ),
          ),
          body:Container(
            color: Colors.lightBlue,
            alignment: Alignment.center,
            child: TabBarView(
                children:[
                  //Tab 1 - Search for friends
                  Column(
                      children:[
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: (value){
                            updateUsersList(value);
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.lightBlueAccent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search friends",
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: userDisplayList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: (){
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        userDisplayList[index],
                                        style: const TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () {
                                            _firestoreDatabase.friendRequestFunction(userList[index]);
                                          }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),]
                  ),

                  //Tab 2 - Friend Requests
                  ListView.builder(
                    itemCount: friendReqNameList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: (){},
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                friendReqNameList[index],
                                style: const TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    bool ifCurrentUserIsFriends = await _firestoreDatabase
                                        .checkForFriendCurrentUser(
                                        friendReqNameList[index]);
                                    if (!ifCurrentUserIsFriends) {
                                      await _firestoreDatabase.addUserToFriendList(
                                          friendReqNameList[index]);
                                      await _firestoreDatabase
                                          .addRequestedUserToCurrentUserFriendList(
                                          friendReqNameList[index]);
                                      await _firestoreDatabase.popFriendReqList(
                                          friendReqNameList[index]);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => const Friends()),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //Tab 3 - View Friends
                  Column(
                      children: [
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: (value){
                            updateFriendsNameList(value);
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.lightBlueAccent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search friends",
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: friendsNameDisplayList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: (){},
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        friendsNameDisplayList[index],
                                        style: const TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async{
                                            await _firestoreDatabase.removeFriendCurrentUser(friendsNameDisplayList[index]);
                                            await _firestoreDatabase.removeFriendFriend(friendsNameDisplayList[index]);
                                          }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),]
                  ),

                ]
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
            currentIndex: 0,
            selectedItemColor: Colors.amber,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {

              if(index == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Messages()));
              }
              else if(index == 2){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Feed()),
                );
              }
              else if(index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Profile()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

