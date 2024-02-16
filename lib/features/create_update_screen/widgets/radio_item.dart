import 'package:flutter/material.dart';

class RadioModel {
  bool isSelected;
  final IconData buttonIon;
  final String text;
  final String value;
  final Color color;

  RadioModel(
      this.isSelected, this.buttonIon, this.text, this.color, this.value);
}