import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: primaryLightColor.withOpacity(.8),
          behavior: SnackBarBehavior.floating),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Lottie.asset('assets/lotties/loading.json', width: 200),
      ),
    );
  }
}
