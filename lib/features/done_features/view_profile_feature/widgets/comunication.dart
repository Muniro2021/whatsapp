import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/zego_cloud/audio_screen.dart';
import 'package:uct_chat/features/zego_cloud/video_screen.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/button_icon_box.dart';
import 'package:uct_chat/models/chat_user.dart';

class Comunication extends StatelessWidget {
  const Comunication({
    super.key,
    required this.user,
  });
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonIconBox(
          onTap: () {
            Navigator.pop(context);
          },
          icon: Icons.chat,
        ),
        const SizedBox(
          width: 20,
        ),
        ButtonIconBox(
          onTap: () async {
            String appId = await APIs.getZegoCloudAppId();
            String appSign = await APIs.getZegoCloudAppSign();
            APIs.sendPushNotification(user, "You Have Voice Call");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AudioInvitationPage(
                  callId: user.callId,
                  appId: appId,
                  appSign: appSign,
                ),
              ),
            );
          },
          icon: Icons.call,
        ),
        const SizedBox(
          width: 20,
        ),
        ButtonIconBox(
          onTap: () async {
            String appId = await APIs.getZegoCloudAppId();
            String appSign = await APIs.getZegoCloudAppSign();
            APIs.sendPushNotification(user, "You Have Video Call");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoInvitationPage(
                  callId: user.callId,
                  appId: appId,
                  appSign: appSign,
                ),
              ),
            );
          },
          icon: Icons.video_call,
        ),
      ],
    );
  }
}
