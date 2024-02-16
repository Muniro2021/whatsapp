import 'package:flutter/material.dart';
import 'package:uct_chat/main.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom:  mq.height/ 16, top: mq.height/ 16),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Image.asset("assets/images/uct.png"),
    );
  }
}