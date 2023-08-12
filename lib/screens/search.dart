import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'video.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchSong extends StatefulWidget {
  final String? videoName;

  const SearchSong({super.key, this.videoName});

  @override
  State<SearchSong> createState() => _SearchState();
}

class _SearchState extends State<SearchSong> {
  yt.YouTubeApi? _youtubeApi;
  var videoID = "";
  @override
  void initState() {
    super.initState();
    _initializeYouTubeApi();
    Future.delayed(const  Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Video(videoId: videoID)));
    });
  }

  void _initializeYouTubeApi() async {
    final credentials = auth.clientViaApiKey(
        'AIzaSyCdD9BXlW7v95tEpxnvyeVJwrCD4tvSryk' // Replace with your API Key
    );
    _youtubeApi = yt.YouTubeApi(credentials);
    await _searchVideo();
  }

  Future<void> _searchVideo() async {
    try {
      String? searchQuery = widget.videoName; // accessing videoName

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
        videoID = searchResponse.items![0].id!.videoId!;
        var x = searchResponse.items![0].toJson()['snippet'];
        print(x);
        print('Video ID: $videoID');

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
      body: Container(
        alignment: Alignment.center,
        color: Colors.lightBlue,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              color: Colors.white,
              size: 150,
            ),
          ],
        ),
      ),

    );
  }
}
