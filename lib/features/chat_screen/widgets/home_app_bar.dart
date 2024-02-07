import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/view_profile_screen/view_profile_screen.dart';
import 'package:uct_chat/helper/my_date_util.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewProfileScreen(user: user),
          ),
        );
      },
      child: StreamBuilder(
          stream: APIs.getUserInfo(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            return Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black54)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .05,
                    height: mq.height * .05,
                    imageUrl: list.isNotEmpty ? list[0].image : user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : user.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive,
                                )
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: user.lastActive,
                            ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }
}
