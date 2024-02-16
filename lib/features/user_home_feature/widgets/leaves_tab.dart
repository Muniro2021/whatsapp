import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_leave_screen/create_leave_screen.dart';
import 'package:uct_chat/features/user_home_feature/widgets/leave_card.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/leave_apply.dart';

class UsersLeavesTab extends StatefulWidget {
  const UsersLeavesTab({
    super.key,
  });

  @override
  State<UsersLeavesTab> createState() => _UsersLeavesTabState();
}

class _UsersLeavesTabState extends State<UsersLeavesTab> {
  List<LeaveApply> list = [];
  String selectedOption = "All Leaves";
  @override
  void initState() {
    list.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
          child: Lottie.asset(
            'assets/lotties/floating_action_lottie_button.json',
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CreateLeaveScreen(),
              ),
            );
          }),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedOption,
                  hint: const Text(
                    'Filter',
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Unna',
                      color: Colors.black,
                    ),
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
                  items:
                      <String>['All Leaves', 'My Leaves'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(bottom: mq.height * 0.070),
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedOption == "All Leaves"
                    ? APIs.getAllLeaves()
                    : APIs.getMyLeaves(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => LeaveApply.fromJson(
                                  e.data() as Map<String, dynamic>))
                              .toList() ??
                          [];
                      if (list.isNotEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return LeaveCard(
                              leave: list[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child:
                              Lottie.asset('assets/lotties/empty_leave.json'),
                        );
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
