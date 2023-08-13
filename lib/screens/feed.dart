import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'friends.dart';
import 'messages.dart';
import '../Firebase/auth.dart';
import '../Firebase/database.dart';
import 'profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final Database _firestoreDatabase = Database();

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final ImagePicker picker = ImagePicker();

  String? imageUrl;
  String postValue = '';


  List feedPost = [];
  List feedName = [];
  List feedOGNameList = [];
  List feedBool = [];

  @override
  void initState() {
    super.initState();
    load().then((result) {
      setState(() {});
    });
  }

  Future<String?> getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print(img);
    if (img != null) {
      imageUrl = await uploadImage(img);
      return imageUrl;
    }
    return null;
  }

  Future<String?> uploadImage(XFile? imageFile) async {
    if (imageFile == null) return null;

    String fileName = 'posts/${DateTime.now().toIso8601String()}.jpg';
    UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(File(imageFile.path));

    print("Starting upload to: $fileName");

    try {
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        print('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      print('Upload Error: $e');
    }
    return null;
  }

  Future<void> load() async {
    feedOGNameList = await _firestoreDatabase.feedName();
    feedPost = await _firestoreDatabase.feedPost();
    feedName = feedOGNameList;
    feedBool = await _firestoreDatabase.sendFeedBooleanList();
  }

  void updateFeedNameList(String query) {
    setState(() {
      feedName = feedOGNameList.where((users) => users.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
                onChanged: (value) {
                  updateFeedNameList(value);
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
                  hintText: "Search posts by",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: feedName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {},
                        title: Column(children: [
                          Text(
                            "${feedName[index]} posted",
                            style: const TextStyle(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                fontSize: 19.0),
                              textAlign: TextAlign.left,
                          ),
                          feedBool[index]?
                              Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Image.network(feedPost[index].substring(0, feedPost[index].indexOf(' '))),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,25,0,20),
                              child: Text(
                                feedPost[index].substring(feedPost[index].indexOf(' ')+1, feedPost[index].length),
                                style: const TextStyle(
                                    backgroundColor: Colors.white,
                                    color: Colors.black,
                                    fontSize: 20.0),
                              ),
                            )
                              ]):Text(
                              feedPost[index],
                              style: const TextStyle(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                fontSize: 20.0),
                          )
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Add a new Post"),
                  content: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Post Title",
                          hintText: "Enter a post title",
                        ),
                        onChanged: (value) {
                          setState(() {
                            postValue = value;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await getImage(ImageSource.gallery);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            Text('From Gallery'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await getImage(ImageSource.camera);
                          print(ImageSource);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            Text('From Camera'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child:
                        const Text('Post', style: TextStyle(color: Colors.black)),
                        onPressed: () async {
                          if (postValue.isEmpty) {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => const Feed()),
                            );
                            return;
                          }

                          if (imageUrl != null) {
                            String val = "${imageUrl!} $postValue";
                            await _firestoreDatabase.addFeed(val, true);
                          }
                          else {
                            await _firestoreDatabase.addFeed(postValue, false);
                          }

                          print(imageUrl);
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => const Feed()),
                          );
                        }),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const Feed()),
                        );
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add, color: Colors.black),
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
        currentIndex: 2,
        selectedItemColor: Colors.amber,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Friends()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Messages()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard()),
            );
          } else if (index == 4) {
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
