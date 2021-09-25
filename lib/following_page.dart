import 'package:partyboard_client/clubwidget.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/club.dart';
import 'model/user.dart';
import 'otheruserprofilepage.dart';

class FollowingPage extends StatelessWidget {
  final List<User> users;
  final List<Club> clubs;
  const FollowingPage(this.users, this.clubs, {Key? key}) : super(key: key);

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
                        return ClubWidget(clubs[index], true);
                      }));
                    },
                    leading: ProfileImageWidget(clubs[index].image, 40),
                    title: Text(
                      clubs[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(CupertinoIcons.forward),
                  );
                },
                childCount: clubs.length, // 1000 list items
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
                                  OtherUserProfilePage(users[index])));
                    },
                    leading: ProfileImageWidget(users[index].image, 40),
                    title: Text(
                      users[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      users[index].about,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: FollowButton(true),
                  );
                },
                childCount: users.length, // 1000 list items
              ),
            ),
          ],
        ));
  }
}
