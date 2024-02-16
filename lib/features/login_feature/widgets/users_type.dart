import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/admin_home_feature/home_screen.dart';
import 'package:uct_chat/features/login_feature/cubit/login_screen_cubit.dart';
import 'package:uct_chat/features/login_feature/widgets/role_card.dart';
import 'package:uct_chat/features/user_home_feature/home_screen.dart';
import 'package:uct_chat/helper/dialogs.dart';

class UsersType extends StatefulWidget {
  const UsersType({super.key});

  @override
  State<UsersType> createState() => _UsersTypeState();
}

class _UsersTypeState extends State<UsersType> {
  @override
  void initState() {
    var loginScreenCubit = BlocProvider.of<LoginScreenCubit>(context);
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loginScreenCubit.changeIsAnimate();
    });
  }

  _handleGoogleBtnClick(int role) {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if ((await APIs.userExists())) {
          navigateToHomeUserExist(role);
        } else {
          await navigateToHomeAfterCreateUser(role);
        }
      }
    });
  }

  Future<void> navigateToHomeAfterCreateUser(int role) async {
    await APIs.createUser(role).then((value) {
      role == 0
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const UserHomeScreen(),
              ),
              (route) => false,
            )
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminHomeScreen(),
              ),
              (route) => false,
            );
    });
  }

  void navigateToHomeUserExist(int role) {
    role == 0
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const UserHomeScreen(),
            ),
            (route) => false,
          )
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminHomeScreen(),
            ),
            (route) => false,
          );
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['profile', 'email']).signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginScreenCubit, LoginScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: const RoleCard(
                image: "assets/images/admin.png",
                role: "Admin",
              ),
              onTap: () async {
                String adminPassword = await APIs.getAdminPassword();
                _showDialog(adminPassword);
              },
            ),
            InkWell(
              child: const RoleCard(
                image: "assets/images/user.png",
                role: "User",
              ),
              onTap: () {
                _handleGoogleBtnClick(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialog(String password) async {
    GlobalKey<FormState> key = GlobalKey();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Admin Access'),
          content: Form(
            key: key,
            child: TextFormField(
              validator: (value) {
                if (value != password) {
                  return "Wrong Password";
                } else if (value!.isEmpty) {
                  return "Enter Password";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Enter Password",
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (key.currentState!.validate()) {
                  _handleGoogleBtnClick(1);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
