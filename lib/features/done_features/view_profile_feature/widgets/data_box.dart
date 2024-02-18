import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class DataBox extends StatelessWidget {
  const DataBox({
    super.key,
    required this.text,
    required this.color,
    required this.verticalPadding,
    required this.horizontalPadding,
    this.rating,
  });
  final String text;
  final Color color;
  final double verticalPadding;
  final double horizontalPadding;
  final int? rating;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: rating != null && rating != 0
            ? SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: rating,
                  itemExtent: 60,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: seconderyLightColor,
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: whiteColor,
                  fontFamily: 'Unna',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
