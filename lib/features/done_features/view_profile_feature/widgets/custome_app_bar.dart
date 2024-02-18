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
              user.id == APIs.me.id
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
                              await logoutFunc(context);
                              await APIs.deleteUser(APIs.me.id);
                              await APIs.auth.currentUser!.delete();
                            },
                          ).show();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit Profile'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete Account'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
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
