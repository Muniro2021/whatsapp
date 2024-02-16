import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/admin_statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/features/admin_statistics_feature/widgets/data_counter.dart';

class UpdatesCard extends StatelessWidget {
  const UpdatesCard({
    super.key,
    required this.month,
    required this.year, required this.userId,
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
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.blue.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.blue,
                  future: StatisticDataAPI.getUserInfoUpdates(year, month, userId),
                ),
                const Text(
                  "Info",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Colors.orange.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.orange,
                  future: StatisticDataAPI.getUserWarninigUpdates(year, month, userId),
                ),
                const Text(
                  "Warning",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.red,
                  future: StatisticDataAPI.getUserUrgentUpdates(year, month, userId),
                ),
                const Text(
                  "Urgent",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.handHoldingHeart,
                  color: Colors.green.withOpacity(0.4),
                ),
                DataCounter(
                  color: Colors.green,
                  future: StatisticDataAPI.getUserGoodUpdates(year, month, userId),
                ),
                const Text(
                  "Good",
                  style: TextStyle(fontFamily: 'Unna', fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
