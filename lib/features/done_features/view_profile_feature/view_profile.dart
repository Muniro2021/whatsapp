// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/custom_app_body.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/custome_app_bar.dart';
import 'package:uct_chat/helper/refresh_widget_state.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.user});
  final ChatUser user;
  

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ViewProfile(user: widget.user),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 2000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    print("Viewed Profile: ${widget.user.id}");
    return Scaffold(
      backgroundColor: primaryLightColor,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        physics: const BouncingScrollPhysics(),
        header: const WaterDropHeader(
          refresh: RefreshWidgetState(messageStatus: "Loading"),
          complete: RefreshWidgetState(messageStatus: "Refresh Completed"),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          children: [
            CustomAppBar(user: widget.user),
            CustomAppBody(user: widget.user)
          ],
        ),
      ),
    );
  }
}
