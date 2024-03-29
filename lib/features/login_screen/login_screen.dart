import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uct_chat/features/login_screen/cubit/login_screen_cubit.dart';

import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
import '../home_screen/home_screen.dart';

//login screen -- implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    var loginScreenCubit = BlocProvider.of<LoginScreenCubit>(context);
    super.initState();
    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      loginScreenCubit.changeIsAnimate();
    });
  }

  // handles google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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
    var loginScreenCubit = BlocProvider.of<LoginScreenCubit>(context);
    return BlocConsumer<LoginScreenCubit, LoginScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Welcome to UCT Chat'),
          ),

          //body
          body: Stack(children: [
            //app logo
            AnimatedPositioned(
                top: mq.height * .15,
                right: loginScreenCubit.isAnimate
                    ? mq.width * .25
                    : -mq.width * .5,
                width: mq.width * .5,
                duration: const Duration(seconds: 1),
                child: Image.asset('images/icon.png')),

            //google login button
            Positioned(
                bottom: mq.height * .15,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .06,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 223, 255, 187),
                        shape: const StadiumBorder(),
                        elevation: 1),
                    onPressed: () {
                      _handleGoogleBtnClick();
                    },

                    //google icon
                    icon: Image.asset('images/google.png',
                        height: mq.height * .03),

                    //login with google label
                    label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(text: 'Login with '),
                            TextSpan(
                                text: 'Google',
                                style: TextStyle(fontWeight: FontWeight.w500),),
                          ]),
                    ))),
          ]),
        );
      },
    );
  }
}
