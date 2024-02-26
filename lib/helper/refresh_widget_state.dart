
import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class RefreshWidgetState extends StatelessWidget {
  const RefreshWidgetState({
    super.key,
    required this.messageStatus,
  });
  final String messageStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        messageStatus,
        style: const TextStyle(
          color: seconderyLightColor,
          fontFamily: 'Unna',
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}
