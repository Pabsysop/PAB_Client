import 'package:flutter/cupertino.dart';
import 'package:partyboard_client/constant.dart';
import 'package:flutter/material.dart';

class AvatarsPage extends StatelessWidget {
  final List<String> avatars = ["assets/images/avatar-1.jpg", "assets/images/avatar-2.jpg",
  "assets/images/avatar-3.jpg", "assets/images/avatar-4.jpg"];
  final double size = 256;
  AvatarsPage({Key? key}) : super(key: key);
  final double spacing = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Choose System Provided Avatar", style: TextStyle(fontSize: appBarTitleSize)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        padding: EdgeInsets.fromLTRB(spacing, spacing, spacing, spacing),
        shrinkWrap: true,
        children: new List<Widget>.generate(avatars.length, (index) {
          return new GestureDetector(
            child: new GridTile(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
                  child: Image.asset(
                      avatars[index],
                      width: size,
                      height: size,
                      fit: BoxFit.fill,
                  ),
              ),
            ),
            onTap: () {
              showCupertinoDialog(
                barrierDismissible: false,
                context: context,
                builder: (context){ 
                  return new CupertinoAlertDialog(
                    title: new Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    content: new Text( avatars[index]),
                    actions: <Widget>[
                      new TextButton(
                        onPressed: () {
                          Navigator.pop(context, avatars[index]);
                          Navigator.pop(context, avatars[index]);
                        },
                        child: new Text("OK")
                      )
                    ],
                  );
                }
              );
            },          
          );
        }),
      ),
    );
  }
}
