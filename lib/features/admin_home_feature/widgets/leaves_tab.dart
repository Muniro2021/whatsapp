import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/admin_home_feature/widgets/leave_card.dart';

import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/leave_apply.dart';

class AdminLeavesTab extends StatefulWidget {
  const AdminLeavesTab({
    super.key,
  });

  @override
  State<AdminLeavesTab> createState() => _AdminLeavesTabState();
}

class _AdminLeavesTabState extends State<AdminLeavesTab> {
  List<LeaveApply> list = [];
  @override
  void initState() {
    list.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(bottom: mq.height * 0.070),
              child: StreamBuilder<QuerySnapshot>(
                stream: APIs.getAllLeaves(),
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
