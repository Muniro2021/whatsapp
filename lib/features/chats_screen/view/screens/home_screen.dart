import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_chat/features/chats_screen/cubit/chats_cubit.dart';

import '../../../../api/apis.dart';
import '../../../../helper/dialogs.dart';
import '../../../../main.dart';
import '../../../../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import '../../../profile_screen/profile_screen.dart';

//home screen -- where all available contacts are shown
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    var chatsCubit = BlocProvider.of<ChatsCubit>(context);
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        return GestureDetector(
          //for hiding keyboard when a tap is detected on screen
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            //if search is on & back button is pressed then close search
            //or else simple close current screen on back button click
            onWillPop: () {
              if (chatsCubit.isSearching) {
                // setState(() {
                chatsCubit.isSearchingChange();
                // });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                //app bar
                appBar: AppBar(
                  backgroundColor: const Color(0xff008069),
                  title: chatsCubit.isSearching
                      ? TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name, Email, ...'),
                          autofocus: true,
                          style:
                              const TextStyle(fontSize: 17, letterSpacing: 0.5),
                          //when search text changes then updated search list
                          onChanged: (val) {
                            //search logic
                            chatsCubit.searchList.clear();

                            for (var i in chatsCubit.list) {
                              if (i.name
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) {
                                chatsCubit.searchList.add(i);
                                // setState(() {
                                chatsCubit.searchList;
                                // });
                              }
                            }
                          },
                        )
                      : const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'We Chat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // setState(() {});
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),

                    //search user button
                    IconButton(
                      onPressed: () => chatsCubit.isSearchingChange(),
                      icon: Icon(
                        chatsCubit.isSearching
                            ? CupertinoIcons.clear_circled_solid
                            : Icons.search,
                        color: Colors.white,
                      ),
                    ),

                    //more features button
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  bottom: const TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(
                        text: "Chats",
                      ),
                      Tab(
                        text: "Updates",
                      ),
                      Tab(
                        text: "Calls",
                      ),
                    ],
                  ),
                ),

                //floating button to add new user
                floatingActionButton: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff008069),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () => _addChatUserDialog(),
                    child: const Icon(
                      Icons.message,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),

                //body
                body: TabBarView(
                  children: [
                    StreamBuilder(
                      stream: APIs.getMyUsersId(),
                      //get id of only known users
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return StreamBuilder(
                              stream: APIs.getAllUsers(snapshot.data?.docs
                                      .map((e) => e.id)
                                      .toList() ??
                                  []),
                              //get only those user, who's ids are provided
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  //if data is loading
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                  // return const Center(
                                  //     child: CircularProgressIndicator());
                                  //if some or all data is loaded then show it
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final data = snapshot.data?.docs;
                                    chatsCubit.list = data
                                            ?.map((e) =>
                                                ChatUser.fromJson(e.data()))
                                            .toList() ??
                                        [];
                                    if (chatsCubit.list.isNotEmpty) {
                                      return ListView.builder(
                                          itemCount: chatsCubit.isSearching
                                              ? chatsCubit.searchList.length
                                              : chatsCubit.list.length,
                                          padding: EdgeInsets.only(
                                              top: mq.height * .01),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return ChatUserCard(
                                                user: chatsCubit.isSearching
                                                    ? chatsCubit
                                                        .searchList[index]
                                                    : chatsCubit.list[index]);
                                          });
                                    } else {
                                      return const Center(
                                        child: Text('No Connections Found!',
                                            style: TextStyle(fontSize: 20)),
                                      );
                                    }
                                }
                              },
                            );
                        }
                      },
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        //title
        title: const Row(
          children: [
            Icon(
              Icons.person_add,
              color: Color(0xff008069),
              size: 28,
            ),
            Text('Add User')
          ],
        ),

        //content
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            hintText: 'Email Id',
            prefixIcon: const Icon(
              Icons.email,
              color: Color(0xff008069),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        //actions
        actions: [
          //cancel button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff008069),
                fontSize: 16,
              ),
            ),
          ),

          //add button
          MaterialButton(
            onPressed: () async {
              //hide alert dialog
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then(
                  (value) {
                    if (!value) {
                      Dialogs.showSnackbar(context, 'User does not Exists!');
                    }
                  },
                );
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xff008069), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
