import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: mq.height * .2,
          height: mq.height * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: seconderyLightColor,
            borderRadius: BorderRadius.circular(mq.height * .1),
          ),
          child:
              //image from server
              ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .1),
            child: CachedNetworkImage(
              width: mq.height * .2,
              height: mq.height * .2,
              fit: BoxFit.cover,
              imageUrl: imagePath,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(
                  CupertinoIcons.person,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
