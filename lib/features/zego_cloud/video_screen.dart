import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class VideoInvitationPage extends StatelessWidget {
  const VideoInvitationPage(
      {super.key,
      required this.callId,
      required this.appId,
      required this.appSign});
  final String callId;
  final String appId;
  final String appSign;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: int.parse(appId),
      appSign: appSign,
      userID: APIs.me.email,
      userName: APIs.me.name,
      plugins: [ZegoUIKitSignalingPlugin()],
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()

        /// support minimizing
        ..topMenuBarConfig.isVisible = true
        ..topMenuBarConfig.buttons = [
          ZegoMenuBarButtonName.showMemberListButton,
        ]
        ..avatarBuilder = customAvatarBuilder,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
    );
  }
}

Widget customAvatarBuilder(
  BuildContext context,
  Size size,
  ZegoUIKitUser? user,
  Map<String, dynamic> extraInfo,
) {
  return CachedNetworkImage(
    imageUrl: 'https://robohash.org/${user?.id}.png',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) {
      ZegoLoggerService.logInfo(
        '$user avatar url is invalid',
        tag: 'live audio',
        subTag: 'live page',
      );
      return ZegoAvatar(user: user, avatarSize: size);
    },
  );
}
