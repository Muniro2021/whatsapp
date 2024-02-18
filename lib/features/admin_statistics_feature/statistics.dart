import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/custom_app_bar.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/user_statistic.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class AdminStatistic extends StatefulWidget {
  const AdminStatistic({super.key});

  @override
  State<AdminStatistic> createState() => _AdminStatisticState();
}

class _AdminStatisticState extends State<AdminStatistic> {
  late String selectedYear;
  @override
  void initState() {
    selectedYear = DateTime.now().year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(),
          SizedBox(
            height: 500,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: APIs.getAllUsersForAdmin(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                }
                if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there's an error
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    'No users found',
                  ); // Show a message if no users are available
                }
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> userData =
                        snapshot.data!.docs[index].data();
                    ChatUser chatUser = ChatUser.fromJson(userData);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserStatisticFromAdmin(
                              userId: chatUser.id,
                              username: chatUser.name,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                        imageUrl: chatUser.image),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          APIs.deleteUser(chatUser.id);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.red.withOpacity(0.6),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.info,

                                            animType: AnimType.rightSlide,
                                            title: 'Comming Soon..',
                                            desc:
                                                'Under Maintain',
                                            btnCancelOnPress: () {
                                              // Navigator.pop(context);
                                            },
                                          ).show();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: primaryLightColor
                                                .withOpacity(0.6),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                chatUser.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Unna',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
