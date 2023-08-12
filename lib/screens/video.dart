import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dashboard.dart';
import 'feed.dart';
import 'friends.dart';
import 'messages.dart';
import 'profile.dart';

class Video extends StatefulWidget {
  final videoId;
  const Video({super.key,this.videoId});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video>{

  late YoutubePlayerController _controller;

  @override
  void initState(){
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print('Ready!');
                  },
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                    ),
                    const PlaybackSpeedButton(),
                    RemainingDuration(),
                    FullScreenButton(),
                  ],
                )
              ],
            ),
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