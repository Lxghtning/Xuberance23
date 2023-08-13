import 'package:flutter/material.dart';
import 'package:hackathonxcodexuberance/screens/search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'profile.dart';

List genres = ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"];
String genreSelected = "";

class Genre extends StatefulWidget {
  const Genre({Key? key}) : super(key: key);

  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {

  List displayGenres = genres;


  void updateGenresDisplayList(String query){
    setState(() {
      displayGenres = genres.where((users) => users.toLowerCase().contains(query.toLowerCase())).toList();
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
                onChanged: (value){
                  updateGenresDisplayList(value);
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
                  hintText: "Search genres",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: displayGenres.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: (){
                          setState(() {
                            genreSelected = displayGenres[index];
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Song()),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              displayGenres[index],
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
          }else if (index == 3){
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





class Song extends StatefulWidget {
  const Song({super.key});

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song>{

  String token = "BQC0hNugMqdgPMyGUCtv-iONAcMTGaziLfGobSGtO7a2-MqHhJmnd0kvgKTFrU51pv_j655Gyr9o1yd6nPBorEV6wFovERi-kO7GbmUO29WWayj2ZlA";

  Future getData()async{
    String url = 'https://api.spotify.com/v1/recommendations?limit=2&seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genreSelected&seed_tracks=0c6xIDDpzE81m2q797ordA';
    String header = 'Bearer $token';

    http.Response response = await http.get(Uri.parse(url), headers: {'Authorization': header});

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getFirstTrack() async {
    String url = 'https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=$genreSelected&seed_tracks=0c6xIDDpzE81m2q797ordA';

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
        color: Colors.blueGrey,
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
                  //Suggestion text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Text('Artist suggestion for: $genreSelected genre', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 30), // Gives some spacing between the text and the image

                  // Display album photo
                  Image.network(imageURL, height: 300, width: 300, fit: BoxFit.cover),

                  const SizedBox(height: 30), // Gives some spacing between the image and the text

                  // Name of the Artist
                  Text('Artist: $artistName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  // Name of the first Track
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 0, 10),
                    child: Text('Track: $song', style: const TextStyle(fontSize: 20)),
                  ),

                  // Name of the Album
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 0, 10),
                    child: Text('From Album: $lpName', style: const TextStyle(fontSize: 20)),
                  ),

                  // Date Released
                  Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                  child : Text('Released on: $releaseDate', style: const TextStyle(fontSize: 20)),
                  ),

                  const SizedBox(height: 20), // Gives some spacing between the text and the button

                  // Button
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSong(videoName: song)));
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
                  builder: (BuildContext context) => const Messages()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Dashboard()),
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
