import 'dart:math';

import 'package:clubhouse_clone_ui_kit/model/room.dart';
import 'package:clubhouse_clone_ui_kit/model/roomuser.dart';
import 'package:clubhouse_clone_ui_kit/profile_page.dart';
import 'package:clubhouse_clone_ui_kit/roomuserwidget.dart';
import 'package:clubhouse_clone_ui_kit/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';
import 'datas/usersdatas.dart';

class ConversationRoom extends StatelessWidget {
  final Room room;
  const ConversationRoom(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: TextButton.icon(
            onPressed: () => {Navigator.pop(context)},
            style: TextButton.styleFrom(primary: Colors.black),
            icon: Icon(CupertinoIcons.chevron_down),
            label: Text("Hallway")),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.doc)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: ProfileImageWidget(user10.image, 30)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
            color: Colors.white),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(room.clubName.toUpperCase() + ' 🏡',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                      IconButton(
                          onPressed: () => {},
                          icon: Icon(CupertinoIcons.ellipsis))
                    ],
                  ),
                  Text(
                    room.topic,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ...room.users.map((e) => RoomUserWidget(RoomUser(e,
                      isMute: Random().nextBool(),
                      isNew: Random().nextBool(),
                      isOwner: true)))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Followed by the speakers",
                style: TextStyle(fontSize: 14, color: Colors.grey[350]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ...room.followedBySpeakers.map((e) => RoomUserWidget(RoomUser(
                      e,
                      isMute: Random().nextBool(),
                      isNew: Random().nextBool())))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Others in the room",
                style: TextStyle(fontSize: 14, color: Colors.grey[350]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ...room.otherUsers.map((e) => RoomUserWidget(RoomUser(e,
                      isMute: Random().nextBool(), isNew: Random().nextBool())))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: getBottomSheet(context),
    );
  }

  getBottomSheet(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Row(
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "✌🏼 Leave quietly",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(CupertinoIcons.add),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(CupertinoIcons.hand_raised),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          )
        ],
      ),
    );
  }
}
