import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/zego_cloud/video_screen.dart';
import 'package:uct_chat/features/user_home_feature/cubit/home_screen_cubit.dart';
import 'package:uct_chat/features/user_home_feature/widgets/chat_user_card.dart';
import 'package:uct_chat/helper/dialogs.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

class UsersChatsTab extends StatefulWidget {
  const UsersChatsTab({
    super.key,
    required this.homeScreenCubit,
    required Animation<double>? animation,
    required AnimationController? animationController,
  })  : _animation = animation,
        _animationController = animationController;

  final UserHomeScreenCubit homeScreenCubit;
  final Animation<double>? _animation;
  final AnimationController? _animationController;

  @override
  State<UsersChatsTab> createState() => _UsersChatsTabState();
}

class _UsersChatsTabState extends State<UsersChatsTab> {
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
          floatingActionButton: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: "Group Call",
                iconColor: Colors.white,
                bubbleColor: primaryLightColor,
                icon: Icons.call,
                titleStyle: const TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'Unna'),
                onPress: () {
                  videoCall(context);
                },
              ),
              Bubble(
                title: "New User",
                iconColor: Colors.white,
                bubbleColor: primaryLightColor,
                icon: Icons.message,
                titleStyle: const TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'Unna'),
                onPress: () {
                  addUserChat(context);
                },
              ),
            ],
            animation: widget._animation!,
            onPress: () => widget._animationController!.isCompleted
                ? widget._animationController!.reverse()
                : widget._animationController!.forward(),
            iconColor: primaryLightColor,
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
                  stream: APIs.getMyUsersId(),
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
                                        return Slidable(
                                          key: ValueKey(
                                            widget
                                                .homeScreenCubit.list[index].id,
                                          ),
                                          startActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            dismissible: DismissiblePane(
                                                onDismissed: () {
                                              APIs.deleteMyUser(widget
                                                      .homeScreenCubit
                                                      .list[index]
                                                      .id)
                                                  .then(
                                                (value) => APIs.deleteChat(
                                                  APIs.getConversationID(
                                                    widget.homeScreenCubit
                                                        .list[index].id,
                                                  ),
                                                ).then((value) =>
                                                    Navigator.pop(context)),
                                              );
                                            }),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  APIs.deleteMyUser(widget
                                                      .homeScreenCubit
                                                      .list[index]
                                                      .id);
                                                },
                                                backgroundColor:
                                                    const Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          child: ChatUserCard(
                                            user: widget
                                                    .homeScreenCubit.isSearching
                                                ? widget.homeScreenCubit
                                                    .searchList[index]
                                                : widget.homeScreenCubit
                                                    .list[index],
                                          ),
                                        );
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

  Future<dynamic> videoCall(BuildContext context) {
    String callId = '';
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        //title
        title: const Row(
          children: [
            Icon(
              Icons.call_outlined,
              color: primaryLightColor,
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
              color: primaryLightColor,
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
                color: primaryLightColor,
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
                String appId = await APIs.getZegoCloudAppId();
                String appSign = await APIs.getZegoCloudAppSign();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoInvitationPage(
                      callId: callId,
                      appId: appId,
                      appSign: appSign,
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Join',
              style: TextStyle(
                color: primaryLightColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addUserChat(BuildContext context) {
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
            prefixIcon: const Icon(Icons.email, color: primaryLightColor),
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
              style: TextStyle(color: primaryLightColor, fontSize: 16),
            ),
          ),

          //add button
          MaterialButton(
            onPressed: () async {
              //hide alert dialog
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(
                      context,
                      'User does not Exists!',
                    );
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: primaryLightColor, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
