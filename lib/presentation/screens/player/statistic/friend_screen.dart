import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FriendScreen extends StatefulWidget {
  final String idPlayer;
  static const String routeName = '/player/friend';

  static void navigateTo(BuildContext context, String idPlayer) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idPlayer = args['idPlayer']!;
    return MaterialPageRoute(
      builder: (context) => FriendScreen(idPlayer: idPlayer),
    );
  }

  const FriendScreen({
    Key? key,
    required this.idPlayer,
  }) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  String _scanQRcode = 'Unknown';
  final _controller = ConfettiController(duration: Duration(seconds: 5));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("Ajouter un ami", style: TextStyle(color: AppColors.white)),
        backgroundColor: currentAppColors.secondaryColor,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<PlayersBloc, PlayersState>(
                listener: (context, state) {
                  if (state.status == PlayersStatus.success) {
                    _showSnackBar(context, 'Ami ajouté', Colors.greenAccent,
                        Icons.check_circle);
                    _controller.play();
                    _scanQRcode = "";
                  } else if (state.status == PlayersStatus.addFriendError) {
                    _showSnackBar(
                        context, state.error, Colors.orangeAccent, Icons.error);
                    _scanQRcode = "";
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case PlayersStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                              AppColors.lightBlue),
                        ),
                        onPressed: () => QrCodeScan(context),
                        child: Text(
                          "Scanner le QrCode de mon ami",
                        ),
                      );
                  }
                },
              ),
            ],
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "Mon QrCode",
                  style: TextStyle(
                    color: currentAppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                QrImageView(
                  data: widget.idPlayer,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  gapless: false,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          'Uh oh! Something went wrong...',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [Colors.indigo, Colors.blue, Colors.redAccent],
            //gravity: 0.5,
          )
        ],
      ),
    );
  }

  Future<void> QrCodeScan(BuildContext context) async {
    String qrCodeScanRes;
    String idFriend = '';

    try {
      qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (qrCodeScanRes == '-1') {
        return;
      }
      idFriend = qrCodeScanRes;
    } on PlatformException {
      qrCodeScanRes = 'Failed to get platform version.';
    }

    if (widget.idPlayer != idFriend) {
      BlocProvider.of<PlayersBloc>(context)
          .add(AddFriend(idPlayer: widget.idPlayer, idFriend: idFriend));
    } else {
      _showSnackBar(context, "Tu ne peux pas t'ajouter toi-même en ami !",
          Colors.orangeAccent, Icons.error);
    }

    if (!mounted) return;
    setState(() {
      _scanQRcode = qrCodeScanRes;
    });
  }

  void _showSnackBar(
      BuildContext context, String text, Color background, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: background,
      ),
    );
  }
}
