import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt));
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.name,
          style: const TextStyle(
            color: primaryLightColor,
            fontFamily: 'Unna',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: seconderyLightColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.position,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: whiteColor,
              fontFamily: 'Unna',
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          user.email,
          style: const TextStyle(
            color: primaryLightColor,
            fontFamily: 'Unna',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Joined At: ",
                  style: TextStyle(
                    color: primaryLightColor,
                    fontFamily: 'Unna',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: primaryLightColor,
                    fontFamily: 'Unna',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            user.id == APIs.me.id
                ? const Text(
                    "id: 8927631678361",
                    style: TextStyle(
                      color: primaryLightColor,
                      fontFamily: 'Unna',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : const SizedBox.square(),
          ],
        ),
      ],
    );
  }
}
