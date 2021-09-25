import 'dart:math';

import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';
import 'otheruserprofilepage.dart';

class FollowersPage extends StatelessWidget {
  final List<User> users;
  const FollowersPage(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FOLLOWERS", style: TextStyle(fontSize: appBarTitleSize)),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (content, index) {
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
              trailing: FollowButton(Random().nextBool()),
            );
          }),
    );
  }
}
