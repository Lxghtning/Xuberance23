import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dashboard.dart';
import 'friends.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;
import '../Firebase/database.dart';
import 'feed.dart';
import 'loading.dart';

final Database _firestoreDatabase = Database();
String nameOfUserSelected = '';

class Messages extends StatefulWidget{
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages>{

  List friendsNameList = [];
  List friendsNameDisplayList = [];

  String? mtoken = " ";
  String error = '';
  String name = '';
  String message = '';

  bool loading = false;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
    load().then((result){
      setState(() {

      });
    });
  }



  Future<void> load() async{
    friendsNameList = await _firestoreDatabase.sendFriendsNameList();
    friendsNameDisplayList = friendsNameList;
  }

  void updateFriendsNameList(String query){
    setState(() {
      friendsNameDisplayList = friendsNameList.where((users) => users.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(context) : Scaffold(
      body:Container(
        color: Colors.blueGrey,
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
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
                    fillColor: Colors.blueGrey[300],
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
                          onTap: (){
                            setState(() {
                              nameOfUserSelected = friendsNameDisplayList[index];
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Inbox()),
                            );
                          },
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]
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
        currentIndex: 1,
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
                  builder: (BuildContext context) => Dashboard()),
            );
          }
        else if(index == 4) {
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

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  List messages = [];
  List messagesBoolean = [];
  String message = '';

  bool state = false;


  @override
  void initState(){
    super.initState();
    load().then((result) async{
      setState(() {

      });
      requestPermission();
    });

  }

  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');
    }
    else{
      print('User declined or has not accepted permission');
    }

  }

  void sendPushMessage(String token, String body, String title) async{
    try {
      await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'applications/json',
            'Authorizations': 'key=AAAA7rMVPsg:APA91bHJLJzcFNV1LwNUh0kKDVzI7kV-9Vs78nr5E70Ggczn2yIVmqsiE-nHtASJV4HdF0WZEXtrc7mBwvtoq5Fg1YwnusUa_GNXtEI9TggOavCojXyveDbhEDDoXWmr7K5sRURVBRsB'
          },
          body: jsonEncode(
              <String, dynamic>{

                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'body': body,
                  'title': title,
                },

                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                  'android_channel_id': 'high_importance_channel',
                },
                'to': token,
              }
          )
      );}
    catch(e){
      print("ERROR IN PUSH NOTIFICATIONS");
    }
  }


  Future<void> load() async{
    messages = await _firestoreDatabase.messagesListSend(nameOfUserSelected);
    print(messages);
    messagesBoolean = await _firestoreDatabase.sendMessagesBooleanList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(nameOfUserSelected),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.blueGrey,
          ),
          body:Container(
            color: Colors.blueGrey,
            child:
                Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: messagesBoolean[index] ? Colors.lightGreenAccent: Colors.white,
                              child: ListTile(
                                onTap: (){
                                },
                                title: Text(
                                  messages[index],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: TextField(
                          onChanged: (value){
                            if(value.isEmpty){
                              return;
                            }
                            setState(() {
                              message = value;
                            });
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Type a message",
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () async{
                                  if(message == ""){
                                    return;
                                  }

                                  await _firestoreDatabase.sendMessageToFriend(nameOfUserSelected, message);
                                  await _firestoreDatabase.sendMessageCurrentUser(nameOfUserSelected, message);

                                  await FirebaseMessaging.instance.getToken().then((token) {
                                    sendPushMessage(token!, nameOfUserSelected, message);
                                    print("token");
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Inbox()),
                                  );

                                }
                            ),
                            suffixIconColor: Colors.black,
                          ),
                        ),
                      ),
                    ]
            ),
          ),
        ),
      ),
    );
  }

}


