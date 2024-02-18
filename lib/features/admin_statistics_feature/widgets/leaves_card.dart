import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/admin_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/data_counter.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';

class LeavesCard extends StatelessWidget {
  const LeavesCard({
    super.key,
    required this.month,
    required this.year,
    required this.userId,
  });
  final int month;
  final String year;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width/4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidClock,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: seconderyLightColor,
                  future:
                      StatisticDataAPI.getUserHourlyLeaves(year, month, userId),
                ),
                const Text(
                  "Hourly",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width/4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.lungsVirus,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: seconderyLightColor,
                  future: StatisticDataAPI.getUserSickLeaves(year, month, userId),
                ),
                const Text(
                  "Sick",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width/4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.calendar,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: seconderyLightColor,
                  future: StatisticDataAPI.getUserAnnualLeaves(year, month, userId),
                ),
                const Text(
                  "Annual",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width/4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.moneyBill,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: seconderyLightColor,
                  future: StatisticDataAPI.getUserUnpaidLeaves(year, month, userId),
                ),
                const Text(
                  "Unpaid",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
