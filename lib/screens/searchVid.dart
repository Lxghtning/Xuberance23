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
        'AIzaSyCdD9BXlW7v95tEpxnvyeVJwrCD4tvSryk' // Replace with your API Key
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
      appBar: AppBar(title: const Text('Search YouTube Video')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter video name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(  // RaisedButton is deprecated, use ElevatedButton instead
              onPressed: () {
                _searchVideo(_controller.text);  // Pass the inputted text to _searchVideo
              },
              child: const Text('Search Video'),
            ),
          ],
        ),
      ),
    );
  }

}