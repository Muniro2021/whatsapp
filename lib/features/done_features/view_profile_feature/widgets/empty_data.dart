import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({
    super.key,
    required this.emptyText,
  });
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: seconderyLightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        emptyText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: whiteColor,
          fontFamily: 'Unna',
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}