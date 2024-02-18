import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class GetMonth extends StatelessWidget {
  const GetMonth({super.key, required this.month, required this.color});
  final int month;
  final bool color;

  @override
  Widget build(BuildContext context) {
    var data = (() {
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
    })();
    return Card(
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Text(
            data,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Unna',
              color: color
                  ? primaryLightColor
                  : seconderyLightColor,
            ),
          )),
        ),
      ),
    );
  }
}
