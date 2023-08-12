import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Song extends StatefulWidget {
  const Song({super.key});

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song>{

  Future getData()async{
    String genre = 'pop';
    String token = "BQCVn-9vfjAh9FJZMQ3Bc8PL4vRf7pERn7g7Ld17mDBz39pazCclFxlLFtKGO-K-pSoyTB1ggxrH-_6gjwZzGCF8GZjV50hhObJra-i0yYyhvx9qxTc";
    String url = 'https://api.spotify.com/v1/recommendations?limit=2&seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genre&seed_tracks=0c6xIDDpzE81m2q797ordA';
    String header = 'Bearer $token';
    
    http.Response response = await http.get(Uri.parse(url), headers: {'Authorization': header});

    return jsonDecode(response.body);
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$artistName \n $lpName \n $type",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // You can display the fetched data here using Text or other widgets
                ],
              );
            }
          },
        ),
      ),
    );
  }


}