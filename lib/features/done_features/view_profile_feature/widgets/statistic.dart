import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/admin_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/data_box.dart';
import 'package:uct_chat/features/done_features/view_profile_feature/widgets/total_text.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/chat_user.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late TextEditingController increase;
  late TextEditingController decrease;
  @override
  void initState() {
    increase = TextEditingController(text: '0');
    decrease = TextEditingController(text: '0');
    super.initState();
  }

  @override
  void dispose() {
    increase.dispose();
    decrease.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentYear = DateTime.now().year.toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const TotalText(text: "Total\nLeaves"),
            const SizedBox(
              width: 10,
              height: 30,
              child: VerticalDivider(),
            ),
            widget.user.id == APIs.me.id ||
                    APIs.me.role == 1 ||
                    widget.user.role == 1
                ? const TotalText(text: "Total\nSalary")
                : const SizedBox.shrink(),
            widget.user.id == APIs.me.id ||
                    APIs.me.role == 1 ||
                    widget.user.role == 1
                ? const SizedBox(
                    width: 10,
                    height: 30,
                    child: VerticalDivider(),
                  )
                : const SizedBox.shrink(),
            const TotalText(text: "Total\nUpdates"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FutureBuilder(
                future: StatisticDataAPI.getAllYearlyLeaves(
                    currentYear, widget.user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DataBox(
                      color: seconderyLightColor,
                      text: "Loading",
                      horizontalPadding: 10,
                      verticalPadding: 20,
                    );
                  } else if (snapshot.hasError) {
                    // If an error occurred while fetching the data, display an error message
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int yearlyLeaves = snapshot.data!;
                    return DataBox(
                      color: seconderyLightColor,
                      text: "$yearlyLeaves",
                      horizontalPadding: 20,
                      verticalPadding: 20,
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.rightSlide,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                const Text(
                                  "Leaves Details",
                                  style: TextStyle(
                                    fontFamily: 'Unna',
                                    fontSize: 20,
                                    color: primaryLightColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyLeaves(
                                              currentYear, widget.user.id, "0"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int hourleLeaves = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "H: $hourleLeaves",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyLeaves(
                                              currentYear, widget.user.id, "1"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int sickLeaves = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "S: $sickLeaves",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyLeaves(
                                              currentYear, widget.user.id, "2"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int anuualLeaves = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "A: $anuualLeaves",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyLeaves(
                                              currentYear, widget.user.id, "3"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int unpaidLeaves = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "U: $unpaidLeaves",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          btnCancelOnPress: () {},
                        ).show();
                      },
                    );
                  }
                }),
            const SizedBox(
              width: 10,
            ),
            widget.user.id == APIs.me.id ||
                    APIs.me.role == 1 ||
                    widget.user.role == 1
                ? DataBox(
                    color: seconderyLightColor,
                    text: widget.user.salary,
                    horizontalPadding: 10,
                    verticalPadding: 20,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Current Salary:",
                                          style: TextStyle(
                                            color: primaryLightColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          widget.user.salary,
                                          style: const TextStyle(
                                            color: seconderyLightColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: increase,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("increase"),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: decrease,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        label: Text("decrease"),
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
                                await APIs.newUserSalary(
                                  userId: widget.user.id,
                                  oldSalary: int.parse(widget.user.salary),
                                  increase: int.parse(increase.text),
                                  decrease: int.parse(decrease.text),
                                );
                                widget.user.salary =
                                    "${int.parse(widget.user.salary) + int.parse(increase.text) - int.parse(decrease.text)}";
                              },
                            ).show()
                          : null;
                    },
                  )
                : const SizedBox.shrink(),
            widget.user.id == APIs.me.id ||
                    APIs.me.role == 1 ||
                    widget.user.role == 1
                ? const SizedBox(
                    width: 10,
                  )
                : const SizedBox.shrink(),
            FutureBuilder(
                future: StatisticDataAPI.getAllYearlyUpdates(
                    currentYear, widget.user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DataBox(
                      color: seconderyLightColor,
                      text: "Loading",
                      horizontalPadding: 10,
                      verticalPadding: 20,
                    );
                  } else if (snapshot.hasError) {
                    // If an error occurred while fetching the data, display an error message
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int yearlyLeaves = snapshot.data!;
                    return DataBox(
                      color: seconderyLightColor,
                      text: "$yearlyLeaves",
                      horizontalPadding: 20,
                      verticalPadding: 20,
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.rightSlide,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                const Text(
                                  "Updates Details",
                                  style: TextStyle(
                                    fontFamily: 'Unna',
                                    fontSize: 20,
                                    color: primaryLightColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyUpdates(currentYear,
                                              widget.user.id, "blue"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int infoUpdates = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "I: $infoUpdates",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyUpdates(currentYear,
                                              widget.user.id, "orange"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int warnningUpdates = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "W: $warnningUpdates",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyUpdates(currentYear,
                                              widget.user.id, "red"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int urgentUpdates = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "U: $urgentUpdates",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: StatisticDataAPI
                                          .getSpecificYearlyUpdates(currentYear,
                                              widget.user.id, "green"),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Expanded(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          int goodUpdates = snapshot.data!;
                                          return DataBox(
                                            color: seconderyLightColor,
                                            text: "G: $goodUpdates",
                                            horizontalPadding: 10,
                                            verticalPadding: 10,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          btnCancelOnPress: () {},
                        ).show();
                      },
                    );
                  }
                }),
          ],
        ),
      ],
    );
  }
}
