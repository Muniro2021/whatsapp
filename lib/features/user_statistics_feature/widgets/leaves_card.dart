import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/user_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/data_counter.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';

class LeavesCard extends StatelessWidget {
  const LeavesCard({
    super.key,
    required this.month,
    required this.year,
  });
  final int month;
  final String year;

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
                  future: StatisticDataAPI.getMyHourlyLeaves(year, month),
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
                  future: StatisticDataAPI.getMySickLeaves(year, month),
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
                  future: StatisticDataAPI.getMyAnnualLeaves(year, month),
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
                  future: StatisticDataAPI.getMyUnpaidLeaves(year, month),
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