import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uct_chat/features/admin_home_feature/home_screen.dart';
import 'package:uct_chat/features/login_feature/login_screen.dart';
import 'package:uct_chat/features/user_home_feature/home_screen.dart';

import '../../../main.dart';
import '../../api/apis.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initDelay();
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //body
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/images/uct.png',
            width: mq.width * 0.6,
          ),
        ),
      ),
    );
  }

  void initDelay() {
    Future.delayed(const Duration(seconds: 4), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
        ),
      );

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        navigateToHomeScreen(context);
        //navigate to home screen
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    });
  }

  static Future<void> navigateToHomeScreen(BuildContext context) async {
    try {
      final docSnapshot =
          await APIs.firestore.collection('users').doc(APIs.me.id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final role = data!['role'];

        if (role == 0) {
          navigateToUserScreen(context);
        } else if (role == 1) {
          navigateToAdminScreen(context);
        } else {
          throw Exception('Invalid user role');
        }
      } else {
        throw Exception('User role not found');
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error or show an error message
    }
  }

  static void navigateToAdminScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
    );
  }

  static void navigateToUserScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserHomeScreen()),
    );
  }
}
