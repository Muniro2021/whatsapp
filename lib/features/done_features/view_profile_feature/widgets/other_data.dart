import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/rating_user.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/comunication.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/statistic.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/user_details.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

class OtherData extends StatefulWidget {
  const OtherData({super.key, required this.user});

  final ChatUser user;

  @override
  State<OtherData> createState() => _OtherDataState();
}

class _OtherDataState extends State<OtherData> {
  int selectedNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mq.height / 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          widget.user.id == APIs.me.id
              ? const SizedBox.shrink()
              : const Comunication(),
          widget.user.id == APIs.me.id
              ? const SizedBox.shrink()
              : const Divider(
                  height: 50,
                ),
          UserDetails(user: widget.user),
          const Divider(
            height: 50,
          ),
          Statistics(user: widget.user),
          const Divider(
            height: 50,
          ),
          InkWell(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                animType: AnimType.rightSlide,
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Rate User",
                      style: TextStyle(
                        color: primaryLightColor,
                        fontSize: 20,
                        fontFamily: 'Unna',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: 5,
                        itemExtent: 50,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              selectedNumber = index + 1;
                            });
                            print(selectedNumber);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedNumber == 0 ? primaryLightColor : seconderyLightColor,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                btnOkOnPress: () {
                  APIs.me.rating = "$selectedNumber";
                },
              ).show();
            },
            child: RatingUser(rating: int.parse(widget.user.rating)),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
