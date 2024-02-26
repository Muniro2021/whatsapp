import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiveEx extends StatefulWidget {
  const RiveEx({super.key});

  @override
  State<RiveEx> createState() => _RiveExState();
}

class _RiveExState extends State<RiveEx> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          DateTime utcDateTime = DateTime.now().toUtc();
          String utcDateTimeString = utcDateTime.toString();
          print(utcDateTimeString);

          DateTime localDateTime = DateTime.parse(utcDateTimeString).toLocal();
          String localDateTimeString = localDateTime.toString();
          print(localDateTimeString);

          DateTime updatedDateTime =
              localDateTime.add(const Duration(hours: 1));
          String updatedDateTimeString = updatedDateTime.toString();
          print(updatedDateTimeString);
        },
        child: const Text("data"),
      )),
    );
  }
}
