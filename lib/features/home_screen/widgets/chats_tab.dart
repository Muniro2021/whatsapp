import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/call_screen/call_screen.dart';
import 'package:uct_chat/features/home_screen/cubit/home_screen_cubit.dart';
import 'package:uct_chat/features/home_screen/widgets/chat_user_card.dart';
import 'package:uct_chat/helper/dialogs.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({
    super.key,
    required this.homeScreenCubit,
    required Animation<double>? animation,
    required AnimationController? animationController,
  })  : _animation = animation,
        _animationController = animationController;

  final HomeScreenCubit homeScreenCubit;
  final Animation<double>? _animation;
  final AnimationController? _animationController;

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  late TextEditingController controller;
  late int roleType;
  @override
  void initState() {
    controller = TextEditingController();
    roleType = APIs.me.role;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (widget.homeScreenCubit.isSearching) {
            widget.homeScreenCubit.changeIsSearching();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          //floating button to add new user
          floatingActionButton: roleType == 1
              ? GestureDetector(
                  child: Lottie.asset(
                    'assets/lotties/floating_action_lottie_button.json',
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                  ),
                  onTap: () {
                    String callId = '';
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        contentPadding: const EdgeInsets.only(
                            left: 24, right: 24, top: 20, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        //title
                        title: const Row(
                          children: [
                            Icon(
                              Icons.call_outlined,
                              color: Color(0xff008069),
                              size: 28,
                            ),
                            Text('Add Call Id')
                          ],
                        ),

                        //content
                        content: TextFormField(
                          maxLines: null,
                          onChanged: (value) => callId = value,
                          decoration: InputDecoration(
                            hintText: 'Call Id',
                            prefixIcon: const Icon(
                              Icons.call_outlined,
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
                              if (callId.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CallInvitationPage(
                                      callId: callId,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Join',
                              style: TextStyle(
                                color: Color(0xff008069),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : FloatingActionBubble(
                  items: <Bubble>[
                    Bubble(
                      title: "Group Call",
                      iconColor: Colors.white,
                      bubbleColor: primaryLightColor,
                      icon: Icons.call,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () {
                        String callId = '';
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: const EdgeInsets.only(
                                left: 24, right: 24, top: 20, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),

                            //title
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.call_outlined,
                                  color: Color(0xff008069),
                                  size: 28,
                                ),
                                Text('Add Call Id')
                              ],
                            ),

                            //content
                            content: TextFormField(
                              maxLines: null,
                              onChanged: (value) => callId = value,
                              decoration: InputDecoration(
                                hintText: 'Call Id',
                                prefixIcon: const Icon(
                                  Icons.call_outlined,
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
                                  if (callId.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CallInvitationPage(
                                          callId: callId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                    color: Color(0xff008069),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Bubble(
                      title: "New User",
                      iconColor: Colors.white,
                      bubbleColor: const Color(0xff008069),
                      icon: Icons.message,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () {
                        String email = '';

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: const EdgeInsets.only(
                                left: 24, right: 24, top: 20, bottom: 10),

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),

                            //title
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: primaryLightColor,
                                  size: 28,
                                ),
                                Text('  Add User')
                              ],
                            ),

                            //content
                            content: TextFormField(
                              maxLines: null,
                              onChanged: (value) => email = value,
                              decoration: InputDecoration(
                                hintText: 'Email Id',
                                prefixIcon:
                                    const Icon(Icons.email, color: primaryLightColor),
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
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: primaryLightColor, fontSize: 16))),

                              //add button
                              MaterialButton(
                                onPressed: () async {
                                  //hide alert dialog
                                  Navigator.pop(context);
                                  if (email.isNotEmpty) {
                                    await APIs.addChatUser(email).then((value) {
                                      if (!value) {
                                        Dialogs.showSnackbar(
                                            context, 'User does not Exists!');
                                      }
                                    });
                                  }
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(
                                      color: primaryLightColor, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  animation: widget._animation!,
                  onPress: () => widget._animationController!.isCompleted
                      ? widget._animationController!.reverse()
                      : widget._animationController!.forward(),
                  iconColor: const Color(0xff008069),
                  iconData: Icons.settings,
                  backGroundColor: Colors.white,
                ),

          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search..',
                            hintStyle: TextStyle(
                              fontFamily: 'Unna',
                            )),
                        autofocus: false,
                        style:
                            const TextStyle(fontSize: 17, letterSpacing: 0.5),
                        //when search text changes then updated search list
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.homeScreenCubit.changeIsSearching();
                      if (widget.homeScreenCubit.isSearching == false) {
                        controller.clear();
                      } else {
                        widget.homeScreenCubit.onChanged(controller.text);
                      }
                    },
                    icon: Icon(
                      widget.homeScreenCubit.isSearching
                          ? CupertinoIcons.clear_circled_solid
                          : Icons.search,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: roleType == 0
                      ? APIs.getMyUsersId()
                      : APIs.getAllUsersForAdmin(),

                  //get id of only known users
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return StreamBuilder(
                          stream: APIs.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),

                          //get only those user, who's ids are provided
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                widget.homeScreenCubit.list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList() ??
                                    [];

                                if (widget.homeScreenCubit.list.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: widget
                                              .homeScreenCubit.isSearching
                                          ? widget
                                              .homeScreenCubit.searchList.length
                                          : widget.homeScreenCubit.list.length,
                                      padding:
                                          EdgeInsets.only(top: mq.height * .01),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(
                                            user: widget
                                                    .homeScreenCubit.isSearching
                                                ? widget.homeScreenCubit
                                                    .searchList[index]
                                                : widget.homeScreenCubit
                                                    .list[index]);
                                      });
                                } else {
                                  return Center(
                                    child: Lottie.asset(
                                      'assets/lotties/empty_chats_list.json',
                                    ),
                                  );
                                }
                            }
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
