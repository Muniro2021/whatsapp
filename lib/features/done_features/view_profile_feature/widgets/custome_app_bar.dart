import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/edit_profile_feature/edit_profile.dart';
import 'package:uct_chat/features/login_feature/login_screen.dart';
import 'package:uct_chat/helper/dialogs.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.user,
  });
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    String deleteUserId = user.id;
    List<PopupMenuEntry<String>> adminList = [
      const PopupMenuItem<String>(
        value: 'edit',
        child: Text(
          'Edit Profile',
          style: TextStyle(fontFamily: 'Unna'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          'Delete Account',
          style: TextStyle(fontFamily: 'Unna'),
        ),
      ),
    ];
    List<PopupMenuEntry<String>> userList = [
      const PopupMenuItem<String>(
        value: 'edit',
        child: Text(
          'Edit Profile',
          style: TextStyle(fontFamily: 'Unna'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          'Delete Account',
          style: TextStyle(fontFamily: 'Unna'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'logout',
        child: Text(
          'Logout',
          style: TextStyle(fontFamily: 'Unna'),
        ),
      ),
    ];
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: whiteColor,
                ),
              ),
              user.id == APIs.me.id || APIs.me.role == 1
                  ? PopupMenuButton<String>(
                      color: whiteColor,
                      onSelected: (String value) async {
                        if (value == 'edit') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfile(user: user),
                            ),
                          );
                        } else if (value == 'logout') {
                          await logoutFunc(context);
                        } else if (value == 'delete') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Delete Account',
                            desc: 'Are You Sure ?!',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              await APIs.deleteUser(deleteUserId);
                              user.id == APIs.me.id
                                  ? await logoutFunc(context)
                                  : Navigator.pop(context);
                              user.id != APIs.me.id
                                  ? Navigator.pop(context)
                                  : null;
                              // await APIs.auth.currentUser!.delete();
                            },
                          ).show();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          user.id == APIs.me.id && APIs.me.role == 1
                              ? userList
                              : user.id != APIs.me.id && APIs.me.role == 1
                                  ? adminList
                                  : userList,
                    )
                  : const SizedBox(
                      width: 20,
                    )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logoutFunc(BuildContext context) async {
    Dialogs.showProgressBar(context);
    await APIs.updateActiveStatus(false);
    APIs.fMessaging.unsubscribeFromTopic('subscribtion');
    await APIs.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        APIs.auth = FirebaseAuth.instance;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      });
    });
  }
}
