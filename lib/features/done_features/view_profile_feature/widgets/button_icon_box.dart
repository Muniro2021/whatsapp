import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class ButtonIconBox extends StatelessWidget {
  const ButtonIconBox({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: seconderyLightColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 20,
          color: whiteColor,
        ),
      ),
    );
  }
}