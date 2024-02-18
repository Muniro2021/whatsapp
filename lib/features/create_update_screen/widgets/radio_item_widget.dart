import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/features/create_update_screen/widgets/radio_item.dart';

class RadioItem extends StatelessWidget {
  const RadioItem({
    super.key,
    required this.item,
  });
  final RadioModel item;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: item.isSelected ? item.color : Colors.transparent,
      ),
      // margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15.0,
            width: 40.0,
            child: Center(
              child: FaIcon(
                item.buttonIon,
                color: item.isSelected ? Colors.white : item.color,
                size: 15.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              item.text,
              style: TextStyle(
                fontSize: 12,
                color: item.isSelected ? Colors.white : item.color,
                fontFamily: 'Unna'
              ),
            ),
          )
        ],
      ),
    );
  }
}
