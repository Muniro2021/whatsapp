import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late TextEditingController callIdController;
  @override
  void initState() {
    callIdController = TextEditingController(text: '000');
    super.initState();
  }

  @override
  void dispose() {
    callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.user.createdAt).toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.user.name,
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
            widget.user.position,
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
          widget.user.email,
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
            widget.user.id == APIs.me.id || APIs.me.role == 1
                ? InkWell(
                    onTap: () {
                      APIs.me.role == 1
                          ? AwesomeDialog(
                              context: context,
                              dialogType: DialogType.noHeader,
                              animType: AnimType.rightSlide,
                              body: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: callIdController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("callId"),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              btnOkOnPress: () async {
                                await APIs.newUserCallId(
                                  userId: widget.user.id,
                                  newCallId: callIdController.text,
                                );
                                widget.user.callId = callIdController.text;
                              },
                            ).show()
                          : null;
                    },
                    child: Text(
                      "Call ID: ${widget.user.callId}",
                      style: const TextStyle(
                        color: primaryLightColor,
                        fontFamily: 'Unna',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : const SizedBox.square(),
          ],
        ),
      ],
    );
  }
}
