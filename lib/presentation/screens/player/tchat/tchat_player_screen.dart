import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_event.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_state.dart';
import 'package:flutter_football/presentation/screens/player/tchat/conversation_item.dart';
import 'package:flutter_football/presentation/screens/player/tchat/message_screen.dart';

class TchatPlayerScreen extends StatefulWidget {
  static const String routeName = '/player/tchat';

  const TchatPlayerScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TchatPlayerScreen(),
    );
  }

  @override
  State<TchatPlayerScreen> createState() => _TchatPlayerScreenState();
}

class _TchatPlayerScreenState extends State<TchatPlayerScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context)
      ..add(GetConversationPlayer())
      ..add(SubscribeToConversation(mode: 'player'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Mes conversations")),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: BlocBuilder<ConversationBloc, ConversationState>(
            builder: (context, state) {
              switch (state.status) {
                case ConversationStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConversationStatus.error:
                  return Center(
                    child: Text(
                      state.error,
                    ),
                  );
                case ConversationStatus.success:
                default:
                  if (state.conversations!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucune conversation, \nAttendez un message de vos entraineurs !",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.conversations!.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations![index];
                      return ConversationItem(
                        conversation: conversation,
                        onTap: () =>
                            _onConversationTap(context, conversation.id),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onConversationTap(BuildContext context, int idConversation) async {
    MessageScreen.navigateTo(context, idConversation.toString());
  }
}
