import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/screens/player/profil/video_screen.dart';

class VideoCarousel extends StatelessWidget {
  final List<Video> videos;

  const VideoCarousel({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoScreen(videoUrl: videos[index].url),
                ),
              );
            },
            child: Container(
              width: 275,
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Image(
                image: AssetImage('assets/images/training.png'),
              ),
            ),
          );
        },
      ),
    );
  }
}
