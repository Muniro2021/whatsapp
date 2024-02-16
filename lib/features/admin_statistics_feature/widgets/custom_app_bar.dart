import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  CustomAppBar({
    super.key,
    this.username,
  });
  String? username;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
          Text(
            widget.username == "" || widget.username == null
                ? "Users"
                : widget.username!,
            style: const TextStyle(
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
