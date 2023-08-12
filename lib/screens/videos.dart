import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  yt.YouTubeApi? _youtubeApi;
  final videoURL = 'https://www.youtube.com/watch?v=YMx8Bbev6T4';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeYouTubeApi();
  }

  void _initializeYouTubeApi() async {
    final credentials = auth.clientViaApiKey(
      'AIzaSyCdD9BXlW7v95tEpxnvyeVJwrCD4tvSryk'// Replace with your API Key
    );
    _youtubeApi = yt.YouTubeApi(credentials);
    await _searchVideo();
  }

  Future<void> _searchVideo() async {
    try {
      final searchQuery = 'Unity - TheFatRat';
      final searchResponse = await _youtubeApi!.search.list(
        ['snippet'],
        q: searchQuery,
        type: ['video'],
      );

      if (searchResponse.items != null && searchResponse.items!.isNotEmpty) {
        final videoId = searchResponse.items![0].id!.videoId;
        var x = searchResponse.items![0].toJson()['snippet'];
        print(x.toJson());
        print('Video ID: $videoId');
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
        title: Text('YouTube Video Search'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}