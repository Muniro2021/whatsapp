import 'package:flutter/material.dart';

class MonthTable extends StatelessWidget {
  final String month;
  final List<String> data;

  const MonthTable({super.key, required this.month, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            month,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Table(
            border: TableBorder.all(),
            defaultColumnWidth: const FixedColumnWidth(120.0),
            children: [
              const TableRow(
                children: [
                  TableCell(
                    child: Center(child: Text('Day')),
                  ),
                  TableCell(
                    child: Center(child: Text('Data')),
                  ),
                ],
              ),
              ...data.map((item) {
                final splitData = item.split(':');
                final day = splitData[0];
                final dataValue = splitData[1];

                return TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text(day)),
                    ),
                    TableCell(
                      child: Center(child: Text(dataValue)),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
