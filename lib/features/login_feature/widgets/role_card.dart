import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.image,
    required this.role,
  });
  final String image;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: const BoxDecoration(),
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                ),
              ),
            ),
            Container(
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'Unna',
                  fontWeight: FontWeight.bold,
                  color: primaryLightColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
