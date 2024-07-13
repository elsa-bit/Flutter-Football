import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/message.dart';
import 'package:flutter_football/presentation/blocs/message/message_bloc.dart';
import 'package:flutter_football/presentation/blocs/message/message_event.dart';
import 'package:flutter_football/presentation/blocs/message/message_state.dart';
import 'package:flutter_football/presentation/screens/player/tchat/message_item.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = '/player/messages';
  final String idConversation;

  const MessageScreen({Key? key, required this.idConversation})
      : super(key: key);

  static void navigateTo(BuildContext context, String idConversation) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idConversation': idConversation},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idConversation = args['idConversation']!;
    return MaterialPageRoute(
      builder: (context) => MessageScreen(idConversation: idConversation),
    );
  }

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late String idPlayer;
  SharedPreferencesDataSource sharedPreferencesDataSource =
      SharedPreferencesDataSource();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    idPlayer = sharedPreferencesDataSource.getIdPlayer()!;

    BlocProvider.of<MessageBloc>(context)
      ..add(GetMessage(idConversation: widget.idConversation))
      ..add(SubscribeToMessages(idConversation: widget.idConversation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("Tchat", style: TextStyle(color: AppColors.white),),
        backgroundColor: currentAppColors.secondaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  switch (state.status) {
                    case MessageStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case MessageStatus.error:
                      return Center(
                        child: Text(
                          state.error,
                        ),
                      );
                    case MessageStatus.success:
                    default:
                      if (state.messages!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Il n'y a pas de messages",
                          ),
                        );
                      }
                      return ListView.builder(
                        reverse: true,
                        itemCount: state.messages!.length,
                        itemBuilder: (context, index) {
                          final message = state.messages![index];
                          return MessageItem(
                            message: message,
                            isCurrentUser: message.role == 'player' &&
                                message.idSender == idPlayer,
                          );
                        },
                      );
                  }
                },
              ),
            ),
            BlocConsumer<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state.status == MessageStatus.addSuccess) {
                  _showSnackBar(context, 'Message ajouté', Colors.green);
                  _messageController.text = "";
                } else if (state.status == MessageStatus.error) {
                  _showSnackBar(
                      context, state.error, Colors.yellowAccent);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case MessageStatus.loading:
                  default:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                labelText: 'Votre message',
                              ),
                            ),
                          ),
                          /*
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () => _selectImage(),
                          ),
                           */
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => {_onAddMessage(context)},
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onAddMessage(BuildContext context) async {
    var bloc = BlocProvider.of<MessageBloc>(context);
    if (_messageController.text != "") {
      final message = Message(
        idConversation: int.parse(widget.idConversation),
        message: _messageController.text,
        idSender: idPlayer,
        role: "player",
      );
      bloc.add(AddMessage(message: message));
    } else {
      _showSnackBar(context, "Ecrivez un message", Colors.redAccent);
    }
  }

  void _showSnackBar(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: background,
      ),
    );
  }
}
