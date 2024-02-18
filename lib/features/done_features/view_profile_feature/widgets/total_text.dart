import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class TotalText extends StatelessWidget {
  const TotalText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: primaryLightColor,
            fontFamily: 'Unna',
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
