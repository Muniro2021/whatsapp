import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/user_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/user_statistics_feature/widgets/data_counter.dart';
import 'package:uct_chat/main.dart';

class UpdatesCard extends StatelessWidget {
  const UpdatesCard({
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
            width: mq.width / 4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.blue.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.blue,
                  future: StatisticDataAPI.getMyInfoUpdates(year, month),
                ),
                const Text(
                  "Info",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width / 4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Colors.orange.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.orange,
                  future: StatisticDataAPI.getMyWarninigUpdates(year, month),
                ),
                const Text(
                  "Warning",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width / 4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.red,
                  future: StatisticDataAPI.getMyUrgentUpdates(year, month),
                ),
                const Text(
                  "Urgent",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: mq.width / 4.5,
            height: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.handHoldingHeart,
                  color: Colors.green.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.green,
                  future: StatisticDataAPI.getMyGoodUpdates(year, month),
                ),
                const Text(
                  "Good",
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
