import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/chat_screen/cubit/chat_screen_cubit.dart';
import 'package:uct_chat/features/chat_screen/widgets/message_card.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';
import 'package:uct_chat/models/message.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    required this.chatScreenCubit,
    required this.user,
  });
  final ChatScreenCubit chatScreenCubit;
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: APIs.getAllMessages(user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              chatScreenCubit.list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (chatScreenCubit.list.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: chatScreenCubit.list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return MessageCard(
                        message: chatScreenCubit.list[index],
                        chatUser: user,
                      );
                    });
              } else {
                return const Center(
                  child: Text(
                    'Say Hii! 👋',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
