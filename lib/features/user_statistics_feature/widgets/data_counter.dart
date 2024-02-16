import 'package:flutter/material.dart';

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
