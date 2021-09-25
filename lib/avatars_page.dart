import 'package:partyboard_client/constant.dart';
import 'package:flutter/material.dart';

class AvatarsPage extends StatelessWidget {
  final List<String> avatars = ["fff", "fsdfs"];
  final double size = 256;
  AvatarsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FOLLOWERS", style: TextStyle(fontSize: appBarTitleSize)),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        children: new List<Widget>.generate(avatars.length, (index) {
          return new GridTile(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
                child: Image.asset(
                    avatars[index],
                    width: size,
                    height: size,
                    fit: BoxFit.fill,
                ),
            ),
          );
        }),            
      ),
    );
  }
}
