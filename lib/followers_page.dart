import 'dart:math';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:flutter/material.dart';
import 'model/user.dart';
import 'otheruserprofilepage.dart';

class FollowersPage extends StatefulWidget {
  final List<User> users;
  FollowersPage(this.users, {Key? key}) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<FollowersPage> with ChangeNotifier {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FOLLOWERS", style: TextStyle(fontSize: appBarTitleSize)),
      ),
      body: ListView.builder(
          itemCount: widget.users.length,
          itemBuilder: (content, index) {
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
              trailing: FollowButton(Random().nextBool()),
            );
          }),
    );
  }
}
