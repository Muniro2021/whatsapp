
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/data_box.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/total_text.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const TotalText(text: "Total\nLeaves"),
            const SizedBox(
              width: 10,
              height: 30,
              child: VerticalDivider(),
            ),
            user.id == APIs.me.id
                ? const TotalText(text: "Total\nSalary")
                : const SizedBox.shrink(),
            user.id == APIs.me.id
                ? const SizedBox(
                    width: 10,
                    height: 30,
                    child: VerticalDivider(),
                  )
                : const SizedBox.shrink(),
            const TotalText(text: "Total\nUpdates"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const DataBox(
              color: seconderyLightColor,
              text: '01',
              horizontalPadding: 20,
              verticalPadding: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            user.id == APIs.me.id
                ? DataBox(
                    color: seconderyLightColor,
                    text: user.salary,
                    horizontalPadding: 10,
                    verticalPadding: 20,
                  )
                : const SizedBox.shrink(),
            user.id == APIs.me.id
                ? const SizedBox(
                    width: 10,
                  )
                : const SizedBox.shrink(),
            const DataBox(
              color: seconderyLightColor,
              text: '32',
              horizontalPadding: 20,
              verticalPadding: 20,
            ),
          ],
        ),
      ],
    );
  }
}
