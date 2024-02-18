import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/login_feature/login_screen.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class MultiFloatingButton extends StatelessWidget {
  const MultiFloatingButton({
    super.key,
    required AnimationController? animationController,
    required Animation<double>? animation,
  })  : _animationController = animationController,
        _animation = animation;

  final AnimationController? _animationController;
  final Animation<double>? _animation;

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      items: <Bubble>[
        Bubble(
          title: "Group Call",
          iconColor: Colors.white,
          bubbleColor: primaryLightColor,
          icon: Icons.call,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {},
          // onPress: () => ChatsHelper.addCallId(context),
        ),
        Bubble(
          title: "New User",
          iconColor: Colors.white,
          bubbleColor: const Color(0xff008069),
          icon: Icons.message,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {},
          // onPress: () => ChatsHelper.addChatUserDialog(context),
        ),
        Bubble(
          title: "Logout",
          iconColor: Colors.white,
          bubbleColor: Colors.redAccent,
          icon: Icons.logout,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
            _animationController!.reverse();
          },
        ),
      ],
      animation: _animation!,
      onPress: () => _animationController!.isCompleted
          ? _animationController!.reverse()
          : _animationController!.forward(),
      iconColor: const Color(0xff008069),
      iconData: Icons.settings,
      backGroundColor: Colors.white,
    );
  }
}
