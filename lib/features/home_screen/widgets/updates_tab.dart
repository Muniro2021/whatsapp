import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_update_screen/create_update_screen.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/update_message.dart';
import 'package:intl/intl.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({
    super.key,
  });

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  List<UpdateMessages> list = [];
  String selectedOption = "All Updates";

  @override
  void initState() {
    list.clear();
    super.initState();
    APIs.getFirebaseMessagingToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: APIs.me.role == 1
          ? GestureDetector(
              child: Lottie.asset(
                'assets/lotties/floating_action_lottie_button.json',
                fit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateUpdateScreen(),
                  ),
                );
              })
          : null,
      body: Column(
        children: [
          APIs.me.role == 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedOption,
                        hint: const Text(
                          'Filter',
                        ), // Optional initial hint text
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                        style: const TextStyle(
                          height: 1,
                          fontFamily: 'Unna',
                          color: Colors.black,
                        ),
                        items: <String>['All Updates', 'My Updates']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: EdgeInsets.only(bottom: mq.height * 0.070),
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedOption == "All Updates"
                    ? APIs.getAllUpdateMessages()
                    : APIs.getMyUpdateMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => UpdateMessages.fromJson(
                                  e.data() as Map<String, dynamic>))
                              .toList() ??
                          [];
                      if (list.isNotEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return UpdateAlert(
                              updateMessages: list[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                            child: Lottie.asset(
                                'assets/lotties/empty_update.json'));
                      }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateAlert extends StatefulWidget {
  const UpdateAlert({
    super.key,
    required this.updateMessages,
  });
  final UpdateMessages updateMessages;

  @override
  State<UpdateAlert> createState() => _UpdateAlertState();
}

class _UpdateAlertState extends State<UpdateAlert> {
  bool isContentVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: SizedBox(
          height: isContentVisible ? null : 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isContentVisible = !isContentVisible;
                  });
                },
                child: ContainerBoxTime(
                  time: widget.updateMessages.time,
                  color: widget.updateMessages.color,
                  mention: widget.updateMessages.mention,
                ),
              ),
              if (isContentVisible) ...[
                ContainerBox(
                  text: widget.updateMessages.subject,
                  title: 'Subject: ',
                  color: widget.updateMessages.color,
                ),
                ContainerBox(
                  text: widget.updateMessages.body,
                  title: 'Body: ',
                  color: widget.updateMessages.color,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerBox extends StatelessWidget {
  const ContainerBox({
    super.key,
    required this.text,
    required this.title,
    required this.color,
  });

  final String text;
  final String title;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          color: (() {
        switch (color) {
          case "red":
            return Colors.red.withOpacity(0.1);
          case "orange":
            return Colors.orange.withOpacity(0.1);
          case "blue":
            return Colors.blue.withOpacity(0.1);
          case "green":
            return Colors.green.withOpacity(0.1);
        }
      })()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                height: 2,
                fontFamily: 'Unna',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: const TextStyle(
              height: 1,
              fontFamily: 'Unna',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerBoxTime extends StatelessWidget {
  const ContainerBoxTime({
    super.key,
    required this.time,
    required this.color,
    required this.mention,
  });

  final String time;
  final String color;
  final String mention;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final formattedDate = DateFormat('MMMM d, EEEE').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          FaIcon(
            (() {
              switch (color) {
                case "red":
                  return FontAwesomeIcons.triangleExclamation;
                case "orange":
                  return FontAwesomeIcons.solidBell;
                case "blue":
                  return FontAwesomeIcons.circleInfo;
                case "green":
                  return FontAwesomeIcons.handHoldingHeart;
              }
            })(),
            color: (() {
              switch (color) {
                case "red":
                  return Colors.red.withOpacity(0.9);
                case "orange":
                  return Colors.orange.withOpacity(0.9);
                case "blue":
                  return Colors.blue.withOpacity(0.9);
                case "green":
                  return Colors.green.withOpacity(0.9);
              }
            })(),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@$mention",
                style: const TextStyle(
                  height: 1,
                  fontFamily: 'Unna',
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      height: 1,
                      fontFamily: 'Unna',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  formattedTime,
                  style: const TextStyle(
                    height: 1,
                    fontFamily: 'Unna',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
