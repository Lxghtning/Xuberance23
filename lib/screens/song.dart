import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'search.dart';



class Song extends StatefulWidget {
  const Song({super.key});

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song>{


  Future getData()async{
    String genre = 'pop';
    String token = "BQAdZf_-VIU6YVajT2PhZzLMWVagtY1Rw1i3VQrb-GOocemMhCdCPurLp_fMrP84SwOzVgJ28ZvtXbj2UzlcTX9B0ZMUK9FZj034uDcvr5B9BFqJhm8";
    String url = 'https://api.spotify.com/v1/recommendations?limit=2&seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genre&seed_tracks=0c6xIDDpzE81m2q797ordA';
    String header = 'Bearer $token';
    
    http.Response response = await http.get(Uri.parse(url), headers: {'Authorization': header});

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getFirstTrack() async {
    String url =
        'https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=rock&seed_tracks=0c6xIDDpzE81m2q797ordA';
    String token = "BQAdZf_-VIU6YVajT2PhZzLMWVagtY1Rw1i3VQrb-GOocemMhCdCPurLp_fMrP84SwOzVgJ28ZvtXbj2UzlcTX9B0ZMUK9FZj034uDcvr5B9BFqJhm8";

    String header = 'Bearer $token';

    http.Response response =
    await http.get(Uri.parse(url), headers: {'Authorization': header});

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
              String song = '';

              if(type == 'single') {
                song = lpName;
              }else {
                getFirstTrack().then((firstTrackData) {
                  print(firstTrackData);
                  song = firstTrackData['tracks'][0]['name'];
                });
              }


              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(videoName: song)));
                  },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }


}