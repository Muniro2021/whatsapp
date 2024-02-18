import 'package:flutter/material.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/data_box.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class RatingUser extends StatelessWidget {
  const RatingUser({
    super.key,
    required this.rating,
  });

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DataBox(
          color: primaryLightColor,
          text: "Admin Rating",
          horizontalPadding: 20,
          verticalPadding: 20,
          rating: rating,
        ),
      ],
    );
  }
}