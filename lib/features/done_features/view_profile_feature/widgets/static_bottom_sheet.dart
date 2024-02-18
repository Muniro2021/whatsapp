
import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class StaticBottomSheet extends StatelessWidget {
  const StaticBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 75,
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}