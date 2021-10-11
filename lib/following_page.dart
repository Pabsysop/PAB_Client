import 'dart:collection';
import 'dart:typed_data';

import 'package:partyboard_client/clubwidget.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/club.dart';
import 'model/user.dart';
import 'otheruserprofilepage.dart';

class FollowingPage extends StatefulWidget {
  final List<User> users;
  final List<Club> clubs;
  final HashMap<String, Uint8List> userAvatarBytes;
  final HashMap<String, String> usersName;

  const FollowingPage(this.users, this.clubs, this.userAvatarBytes, this.usersName, {Key? key}) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<FollowingPage> with ChangeNotifier {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("FOLLOWING", style: TextStyle(fontSize: appBarTitleSize)),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (b) {
                        return ClubWidget(widget.clubs[index], true, widget.users);
                      }));
                    },
                    leading: ProfileImageWidget(widget.clubs[index].cover ?? "", 40),
                    title: Text(
                      widget.clubs[index].title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(CupertinoIcons.forward),
                  );
                },
                childCount: widget.clubs.length, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  OtherUserProfilePage(widget.users[index])));
                    },
                    leading: MemoryImageWidget(widget.users[index].getAvatar(), 40),
                    title: Text(
                      widget.users[index].getName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: FollowButton(true),
                  );
                },
                childCount: widget.users.length, // 1000 list items
              ),
            ),
          ],
        ));
  }
}
