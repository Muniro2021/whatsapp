import 'package:flutter/material.dart';
import 'package:uct_chat/features/admin_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/custom_app_bar.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/get_month.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/leaves_card.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/updates_card.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class UserStatisticFromAdmin extends StatefulWidget {
  const UserStatisticFromAdmin({
    super.key,
    required this.userId,
    required this.username,
  });
  final String userId;
  final String username;

  @override
  State<UserStatisticFromAdmin> createState() => _UserStatisticFromAdminState();
}

class _UserStatisticFromAdminState extends State<UserStatisticFromAdmin> {
  late int selectedMonth = -1;
  late String selectedYear;
  String? time;

  @override
  void initState() {
    selectedMonth = -1;
    selectedYear = DateTime.now().toLocal().year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(username: widget.username),
          yearFilter(),
          SizedBox(
            height: 700,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(seconds: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        child: GetMonth(
                          month: index + 1,
                          color: selectedMonth == index + 1,
                        ),
                        onTap: () async {
                          setState(() {
                            clickedMonth(index);
                          });
                        },
                      ),
                      if (selectedMonth == index + 1) ...[
                        Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(
                                    child: Text(
                                      "Leaves",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Unna',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            LeavesCard(
                              year: selectedYear,
                              month: index + 1,
                              userId: widget.userId,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Total Hours: ",
                                                style: TextStyle(
                                                  fontFamily: 'Unna',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            FutureBuilder<String>(
                                              future: StatisticDataAPI
                                                  .getLeaveHours(
                                                selectedYear,
                                                index + 1,
                                                widget.userId,
                                              ),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  final leaveHours =
                                                      snapshot.data;
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        leaveHours!,
                                                        style: const TextStyle(
                                                            fontFamily: 'Unna',
                                                            fontSize: 20,
                                                            color:
                                                                primaryLightColor),
                                                      ),
                                                      const Text(
                                                        " hours",
                                                        style: TextStyle(
                                                          fontFamily: 'Unna',
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Total Days: ",
                                                style: TextStyle(
                                                  fontFamily: 'Unna',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            FutureBuilder<String>(
                                              future:
                                                  StatisticDataAPI.getLeaveDays(
                                                selectedYear,
                                                index + 1,
                                                widget.userId,
                                              ),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  final leaveDays =
                                                      snapshot.data;
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        leaveDays!,
                                                        style: const TextStyle(
                                                            fontFamily: 'Unna',
                                                            fontSize: 20,
                                                            color:
                                                                primaryLightColor),
                                                      ),
                                                      const Text(
                                                        ' days',
                                                        style: TextStyle(
                                                          fontFamily: 'Unna',
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              child: ListTile(
                                title: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(
                                    child: Text(
                                      "Updates",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Unna'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            UpdatesCard(
                              year: selectedYear,
                              month: index + 1,
                              userId: widget.userId,
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Row yearFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: selectedYear,

          onChanged: (String? newValue) {
            setState(() {
              selectedYear = newValue!;
            });
          },
          style: const TextStyle(
            color: Colors.black, // Text color
            fontSize: 16.0, // Text font size
            fontWeight: FontWeight.bold, // Text font weight
          ),
          dropdownColor: Colors.grey[200], // Dropdown background color
          icon: const Icon(
            Icons.arrow_drop_down, // Dropdown arrow icon
            color: Colors.black,
          ),
          items: <String>['2023', '2024', '2025'].map((String year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(year),
            );
          }).toList(),
        ),
      ],
    );
  }

  void clickedMonth(int index) {
    if (selectedMonth == index + 1) {
      selectedMonth = -1; // Deselect the month if it's already selected
    } else {
      selectedMonth = index + 1;
    }
  }
}
