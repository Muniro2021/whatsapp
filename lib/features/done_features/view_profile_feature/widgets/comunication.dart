

import 'package:flutter/material.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/button_icon_box.dart';

class Comunication extends StatelessWidget {
  const Comunication({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonIconBox(
          onTap: () {},
          icon: Icons.chat,
        ),
        const SizedBox(
          width: 20,
        ),
        ButtonIconBox(
          onTap: () {},
          icon: Icons.call,
        ),
        const SizedBox(
          width: 20,
        ),
        ButtonIconBox(
          onTap: () {},
          icon: Icons.video_call,
        ),
      ],
    );
  }
}