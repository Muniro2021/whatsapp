import 'package:flutter/material.dart';
import 'package:uct_chat/features/login_feature/widgets/logo.dart';
import 'package:uct_chat/features/login_feature/widgets/register_as.dart';
import 'package:uct_chat/features/login_feature/widgets/users_type.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Logo(),
              RegisterAs(),
              UsersType(),
            ],
          ),
        ),
      ),
    );
  }
}
