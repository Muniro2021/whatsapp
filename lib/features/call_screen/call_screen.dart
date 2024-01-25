import 'package:flutter/material.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage({
    super.key,
    required this.callID,
    required this.chatUser,
  });
  final String callID;
  final ChatUser chatUser;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1134576799,
      appSign:
          "387466bb25fc8e377322e819b0f9e28eae83328d5375ca26b179eba7d1ed9d8c",
      userID: chatUser.id,
      userName: chatUser.name,
      plugins: [ZegoUIKitSignalingPlugin()],
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.pop(context),
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
    );
  }
}