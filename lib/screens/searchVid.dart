import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'dashboard.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'video.dart';
import 'profile.dart';

class SearchVid extends StatefulWidget {
  const SearchVid({super.key});

  @override
  State<SearchVid> createState() => _SearchVidState();
}

class _SearchVidState extends State<SearchVid> {
  yt.YouTubeApi? _youtubeApi;
  var id = "";
  final _controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    _initializeYouTubeApi();
  }

  void _initializeYouTubeApi() async {
    final credentials = auth.clientViaApiKey(
        'Enter API-Key Here' // Replace with your API Key
    );
    _youtubeApi = yt.YouTubeApi(credentials);
  }

  Future<void> _searchVideo(String? searchQuery) async {
    try {

      if (searchQuery == null) {
        print('Search query is null.');
        return;
      }

      final searchResponse = await _youtubeApi!.search.list(
        ['snippet'],
        q: searchQuery,
        type: ['video'],
      );

      if (searchResponse.items != null && searchResponse.items!.isNotEmpty) {
        id = searchResponse.items![0].id!.videoId!;
        var x = searchResponse.items![0].toJson()['snippet'];
        print(x);
        print('Video ID: $id');

        Navigator.push(context, MaterialPageRoute(builder: (context) => Video(videoId: id)));

        // Now you have the video ID, you can use it to display the video or perform other operations.
      } else {
        print('No videos found.');
      }
    } catch (e) {
      print('Error searching for videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Search Video'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextField(
                  controller: _controller,
                  onChanged: (value){
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
                    hintText: "Search for a video",
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async{
                          _searchVideo(_controller.text);
                        }
                    ),
                    suffixIconColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  BottomNavigationBar(
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
