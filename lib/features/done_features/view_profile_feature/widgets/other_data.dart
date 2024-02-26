import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/comunication.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/statistic.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/user_details.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

class OtherData extends StatefulWidget {
  const OtherData({super.key, required this.user});

  final ChatUser user;

  @override
  State<OtherData> createState() => _OtherDataState();
}

class _OtherDataState extends State<OtherData> {
  int selectedNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mq.height / 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          widget.user.id == APIs.me.id
              ? const SizedBox.shrink()
              : Comunication(
                  user: widget.user,
                ),
          widget.user.id == APIs.me.id
              ? const SizedBox.shrink()
              : const Divider(
                  height: 50,
                ),
          UserDetails(user: widget.user),
          const Divider(
            height: 50,
          ),
          Statistics(user: widget.user),
          const Divider(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: RatingBar.builder(
              initialRating: double.parse(widget.user.rating),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: seconderyLightColor,
              ),
              onRatingUpdate: (rating) {
                if (widget.user.role == 1 || APIs.me.role == 1) {
                  widget.user.rating = rating.toString();
                  APIs.updateRatingStatus(rating.toString(), widget.user.id);
                }
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
