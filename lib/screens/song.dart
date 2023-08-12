import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'search.dart';
import'profile.dart';


class Song extends StatefulWidget {
  const Song({super.key});

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song>{

  String token = "BQBgT_LQMdhV4hz5JZ1YomcpTgLtk0NdDFJdSmr1ldh2jk2H3svqorqJBzNQuNsPaGTgQ1swdPhyyHUgUKg3h1htr7wQdawnEdhmE1N2WS7FxsNJG1I";
  String genre = 'pop';

  Future getData()async{
    String url = 'https://api.spotify.com/v1/recommendations?limit=2&seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genre&seed_tracks=0c6xIDDpzE81m2q797ordA';
    String header = 'Bearer $token';
    
    http.Response response = await http.get(Uri.parse(url), headers: {'Authorization': header});

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getFirstTrack() async {
    String url = 'https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genre&seed_tracks=0c6xIDDpzE81m2q797ordA';

    String header = 'Bearer $token';

    http.Response response = await http.get(Uri.parse(url), headers: {'Authorization': header});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.lightBlue,
        child: FutureBuilder(
          future: getData(), // This is your async function that returns a Future
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Display a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('No data available');
            } else {
              // Data has been successfully fetched and is available in snapshot.data
              // You can now access and use the JSON data here
              Map<String, dynamic> jsonData = snapshot.data;
              // Now you can access the data in the jsonData map
              print(jsonData);
              var artistName = jsonData['tracks'][0]['artists'][0]['name'];
              var lpName = jsonData['tracks'][0]['album']['name'];
              var imageURL = jsonData['tracks'][0]['album']['images'][0]['url'];
              var type = jsonData['tracks'][0]['album']['album_type'];
              var releaseDate = jsonData['tracks'][0]['album']['release_date'];
              var id = jsonData['tracks'][0]['album']['id'];
              String song = lpName;

              if (type != 'single'){
                getFirstTrack().then((firstTrackData) {
                  print(firstTrackData);
                  song = firstTrackData['tracks'][0]['name'];
                });
              }


              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display album photo
                  Image.network(imageURL, height: 300, width: 300, fit: BoxFit.cover),

                  const SizedBox(height: 20), // Gives some spacing between the image and the text

                  // Name of the Artist
                  Text('Artist: $artistName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  // Name of the first Track
                  Text('Track: $song', style: const TextStyle(fontSize: 20)),

                  // Name of the Album
                  Text('From Album: $lpName', style: const TextStyle(fontSize: 20)),

                  // Date Released
                  Text('Released on: $releaseDate', style: const TextStyle(fontSize: 20)),

                  const SizedBox(height: 20), // Gives some spacing between the text and the button

                  // Button
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Search(videoName: song)));
                      },
                      child: const Text('Watch on YouTube')
                  ),
                ],
              );

            }
          },
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


}