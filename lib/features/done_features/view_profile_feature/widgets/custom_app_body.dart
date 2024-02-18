// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/image_profile.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/other_data.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/static_bottom_sheet.dart';
import 'package:uct_chat/models/chat_user.dart';

class CustomAppBody extends StatelessWidget {
  const CustomAppBody({
    super.key,
    required this.user,
  });
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          const StaticBottomSheet(),
          ImageProfile(imagePath: user.image),
          OtherData(user: user)
        ],
      ),
    );
  }
}
