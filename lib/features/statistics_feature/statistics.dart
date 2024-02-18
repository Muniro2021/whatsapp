import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/statistics_feature/data/statistic_data_api.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool monthStatisticView = false;
    print(monthStatisticView);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CustomAppBar(),
          SizedBox(
            height: 700,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        child: GetMonth(month: index + 1),
                        onTap: () {
                          setState(() {
                            monthStatisticView = !monthStatisticView;
                          });
                        },
                      ),
                      monthStatisticView
                          ? Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                        child: Text(
                                          "Leaves",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Unna',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                LeavesCard(month: index + 1),
                                Card(
                                  child: ListTile(
                                    title: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                        child: Text(
                                          "Updates",
                                          style: TextStyle(
                                              fontSize: 30, fontFamily: 'Unna'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                UpdatesCard(month: index + 1),
                              ],
                            )
                          : const SizedBox(),
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
}

class GetMonth extends StatelessWidget {
  const GetMonth({super.key, required this.month});
  final int month;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Text(
            (() {
              switch (month) {
                case 1:
                  return "January";
                case 2:
                  return "February";
                case 3:
                  return "March";
                case 4:
                  return "April";
                case 5:
                  return "May";
                case 6:
                  return "June";
                case 7:
                  return "July";
                case 8:
                  return "August";
                case 9:
                  return "September";
                case 10:
                  return "October";
                case 11:
                  return "November";
                default:
                  return "December";
              }
            })(),
            style: const TextStyle(fontSize: 30, fontFamily: 'Unna'),
          )),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              child: const Icon(Icons.arrow_back_ios),
              onTap: () => Navigator.pop(context),
            ),
          ),
          const Text(
            "Statistic",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Unna',
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

class UpdatesCard extends StatelessWidget {
  const UpdatesCard({
    super.key,
    required this.month,
  });
  final int month;

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
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMyInfoUpdates(month),
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
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMyWarninigUpdates(month),
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
                  future: StatisticDataAPI.getMyUrgentUpdates(month),
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
                  future: StatisticDataAPI.getMyGoodUpdates(month),
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

class LeavesCard extends StatelessWidget {
  const LeavesCard({
    super.key,
    required this.month,
  });
  final int month;

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
                  FontAwesomeIcons.solidClock,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMyHourlyLeaves(month),
                ),
                const Text(
                  "Hourly",
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
                  FontAwesomeIcons.lungsVirus,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMySickLeaves(month),
                ),
                const Text(
                  "Sick",
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
                  FontAwesomeIcons.calendar,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMyAnnualLeaves(month),
                ),
                const Text(
                  "Annual",
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
                  FontAwesomeIcons.moneyBill,
                  color: primaryLightColor.withOpacity(0.4),
                ),
                DataCounter(
                  color: primaryLightColor,
                  future: StatisticDataAPI.getMyUnpaidLeaves(month),
                ),
                const Text(
                  "Unpaid",
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

class DataCounter extends StatelessWidget {
  const DataCounter({super.key, required this.future, required this.color});
  final Future<int>? future;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error retrieving my_leaves count: ${snapshot.error}');
        } else {
          return Text(
            "${snapshot.data}",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          );
        }
      },
    );
  }
}
