import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = '/player/news';

  const NewsScreen({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => NewsScreen(),
    );
  }

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(
                  "https://www.csbretignyfootball.fr/category/actualites/")),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
          )
        ],
      ),
    );
  }
}
