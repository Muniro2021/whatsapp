import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveEx extends StatefulWidget {
  const RiveEx({super.key});

  @override
  State<RiveEx> createState() => _RiveExState();
}

class _RiveExState extends State<RiveEx> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/car.riv',
        ),
      ),
    );
  }
}
