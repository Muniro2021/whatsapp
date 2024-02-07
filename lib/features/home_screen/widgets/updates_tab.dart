import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    list.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateUpdateScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: APIs.getAllUpdateMessages(),
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
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
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
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: isContentVisible ? 180 : 50,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContainerBoxTime(text: widget.updateMessages.time),
                ],
              ),
            ),
            if (isContentVisible) ...[
              const Divider(),
              ContainerBox(
                text: widget.updateMessages.mention,
                color: widget.updateMessages.color,
              ),
              ContainerBox(text: widget.updateMessages.subject),
              ContainerBox(text: widget.updateMessages.body),
            ]
          ],
        ),
      ),
    );
  }
}

class ContainerBox extends StatelessWidget {
  const ContainerBox({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (() {
          switch (color) {
            case "red":
              return Colors.red.withOpacity(0.2);
            case "orange":
              return Colors.orange.withOpacity(0.2);
            case "blue":
              return Colors.blue.withOpacity(0.2);
            case "green":
              return Colors.green.withOpacity(0.2);
          }
        })(),
      ),
      child: Text(text),
    );
  }
}

class ContainerBoxTime extends StatelessWidget {
  const ContainerBoxTime({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final String? color;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(text));
    final formattedDateTime =
        DateFormat('MMMM d, EEEE - HH:mm').format(dateTime);
    print(formattedDateTime);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (() {
          switch (color) {
            case "red":
              return Colors.red.withOpacity(0.2);
            case "orange":
              return Colors.orange.withOpacity(0.2);
            case "blue":
              return Colors.blue.withOpacity(0.2);
            case "green":
              return Colors.green.withOpacity(0.2);
          }
        })(),
      ),
      child: Text(formattedDateTime),
    );
  }
}
