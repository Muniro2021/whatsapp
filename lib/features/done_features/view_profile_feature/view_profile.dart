// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/custom_app_body.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/custome_app_bar.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.user});
  final ChatUser user;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryLightColor,
      body: Column(
        children: [
          CustomAppBar(user: widget.user),
          CustomAppBody(user: widget.user)
        ],
      ),
    );
  }
}
