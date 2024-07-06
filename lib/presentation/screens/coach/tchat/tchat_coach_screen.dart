import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_event.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_state.dart';
import 'package:flutter_football/presentation/screens/coach/tchat/conversation_item_coach.dart';
import 'package:flutter_football/presentation/screens/coach/tchat/message_coach_screen.dart';

class TchatCoachScreen extends StatefulWidget {
  static const String routeName = '/coach/tchat';

  const TchatCoachScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TchatCoachScreen(),
    );
  }

  @override
  State<TchatCoachScreen> createState() => _TchatCoachScreenState();
}

class _TchatCoachScreenState extends State<TchatCoachScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context)
      ..add(GetConversationCoach())
      ..add(SubscribeToConversation(mode: 'coach'));
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
                          "Aucune Conversation, créer en une dès maintenant !"),
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
    MessageCoachScreen.navigateTo(context, idConversation.toString());
  }
}
