import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/chat_screen/cubit/chat_screen_cubit.dart';
import 'package:uct_chat/features/chat_screen/widgets/chat_box.dart';
import 'package:uct_chat/features/chat_screen/widgets/home_app_bar.dart';
import 'package:uct_chat/features/chat_screen/widgets/message_input.dart';

import '../../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textController;

  @override
  void initState() {
    var chatScreenCubit = BlocProvider.of<ChatScreenCubit>(context);
    textController = TextEditingController();
    chatScreenCubit.initialRecorder();
    super.initState();
  }

  @override
  void dispose() {
    var chatScreenCubit = BlocProvider.of<ChatScreenCubit>(context);
    textController.dispose();
    chatScreenCubit.record.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ChatScreen other user : ${widget.user.id}");
    print("ChatScreen me : ${APIs.me.id}");
    var chatScreenCubit = BlocProvider.of<ChatScreenCubit>(context);
    return Scaffold(
      body: BlocConsumer<ChatScreenCubit, ChatScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: WillPopScope(
                onWillPop: chatScreenCubit.onWillPop,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    flexibleSpace: HomeAppBar(
                      user: widget.user,
                    ),
                    elevation: 0,
                    actions: [
                      IconButton(
                        onPressed: () {
                          APIs.deleteChat(
                            APIs.getConversationID(widget.user.id),
                          ).then((value) => Navigator.pop(context));
                        },
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                  backgroundColor: const Color.fromARGB(255, 234, 248, 255),
                  body: Column(
                    children: [
                      ChatBox(
                        chatScreenCubit: chatScreenCubit,
                        user: widget.user,
                      ),
                      if (chatScreenCubit.isUploading)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      MessageInput(
                        chatScreenCubit: chatScreenCubit,
                        user: widget.user,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
