import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String image;
  final double size;
  const ProfileImageWidget(this.image, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
      child: Image.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.fill,
      ),
    );
  }
}
