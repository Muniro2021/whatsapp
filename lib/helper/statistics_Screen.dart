import 'package:flutter/material.dart';
import 'package:uct_chat/helper/month_table.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final List<String> januaryData = [
    '1: Data 1',
    '2: Data 2',
    '3: Data 3',
  ];

  final List<String> februaryData = [
    '1: Data 1',
    '2: Data 2',
    '3: Data 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month Tables'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MonthTable(month: 'January', data: januaryData),
            MonthTable(month: 'February', data: februaryData),
          ],
        ),
      ),
    );
  }
}