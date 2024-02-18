
import 'package:flutter/material.dart';

class RegisterAs extends StatelessWidget {
  const RegisterAs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40, top: 100),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Register as",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Unna',
              color: Colors.black87.withOpacity(0.8),
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}