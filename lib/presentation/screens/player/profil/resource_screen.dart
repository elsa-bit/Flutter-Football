import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:flutter_football/presentation/screens/player/profil/video_carousel.dart';

class ResourceScreen extends StatefulWidget {
  static const String routeName = '/player/resources';

  const ResourceScreen({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => ResourceScreen(),
    );
  }

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MediaBloc>(context)
        .add(GetVideosBucket(bucketName: "trainingGeneral"));
    //get video speicifque poste - general - prepa physique
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes ressources"),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          switch (state.status) {
            case MediaStatus.loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            case MediaStatus.error:
              return Center(
                child: Text(
                  state.error!,
                ),
              );
            case MediaStatus.success:
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Techniques (en fonction de son poste)',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  VideoCarousel(videos: state.videos!),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Entrainement général',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  VideoCarousel(videos: state.videos!),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Préparation physique',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  VideoCarousel(videos: state.videos!),
                ],
              );
            default:
              return const Center(
                child: Text("Pas de vidéo trouvé !"),
              );
          }
        },
      ),
    );
  }
}
