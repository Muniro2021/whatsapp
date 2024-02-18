
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/helper/dialogs.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';

class UpdateBtn extends StatelessWidget {
  const UpdateBtn({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: primaryLightColor,
        minimumSize: Size(mq.width * .5, mq.height * .06),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          APIs.updateUserInfo().then((value) {
            Dialogs.showSnackbar(context, 'Profile Updated Successfully!');
          });
        }
      },
      icon: const Icon(Icons.edit, size: 28),
      label: const Text(
        'UPDATE',
        style: TextStyle(fontSize: 16, fontFamily: 'Unna'),
      ),
    );
  }
}
