import 'package:flutter/material.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/custom_app_bar.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/get_month.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/leaves_card.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/updates_card.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class UserStatistic extends StatefulWidget {
  const UserStatistic({super.key});

  @override
  State<UserStatistic> createState() => _UserStatisticState();
}

class _UserStatisticState extends State<UserStatistic> {
  late int selectedMonth = -1;
  late String selectedYear;

  @override
  void initState() {
    selectedMonth = -1;
    selectedYear = DateTime.now().year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CustomAppBar(),
          YearFilter(),
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
                        onTap: () {
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
                            LeavesCard(year: selectedYear, month: index + 1),
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
                            UpdatesCard(year: selectedYear, month: index + 1),
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

  Row YearFilter() {
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
              child: Text(year, style: const TextStyle(color: primaryLightColor, fontFamily: 'Unna'),),
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
