import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_bloc.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocScreen extends StatefulWidget {
  static const String routeName = '/document';

  const DocScreen({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => DocScreen(),
    );
  }

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  String? docClubUrl;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MediaBloc>(context).add(GetDocumentClub());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MediaBloc, MediaState>(
          listener: (context, state) {
            switch (state.status) {
              case MediaStatus.success:
                setState(() {
                  docClubUrl = state.response?.url;
                });
                break;
              case MediaStatus.error:
                break;
              default:
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              child: docClubUrl != null
                  ? SfPdfViewer.network(docClubUrl!)
                  : Container(
                height: 300,
                child: Center(child: Text("Pas de document !")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
