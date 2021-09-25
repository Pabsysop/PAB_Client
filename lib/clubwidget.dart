import 'dart:math';

import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/otheruserprofilepage.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/club.dart';

// ignore: must_be_immutable
class ClubWidget extends StatelessWidget {
  final Club club;
  bool isFollowing;

  ClubWidget(this.club, this.isFollowing, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: ProfileImageWidget(club.image, 80)),
                  SizedBox(
                    height: 13,
                  ),
                  Center(
                    child: Text(
                      club.name + ' 🏡',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: headingFontSize),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        club.followers.length.toString() + " Followers",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: bodyFontSize),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(primary: deepBlue),
                          onPressed: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.menu),
                              Text(
                                "Rules",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: FollowButton(
                      isFollowing,
                      onTap: (b) {
                        isFollowing = b;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    "About",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 14, color: Colors.grey),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Text(
                    club.about,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            if (club.followers.isNotEmpty)
              SliverToBoxAdapter(
                child: Text(
                  club.followers.length.toString() + " Members",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 14, color: Colors.grey),
                ),
              ),
            SliverToBoxAdapter(
              child: Divider(
                thickness: 1,
              ),
            ),
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  OtherUserProfilePage(club.followers[index])));
                    },
                    leading:
                        ProfileImageWidget(club.followers[index].image, 40),
                    title: Text(
                      club.followers[index].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      club.followers[index].about,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: FollowButton(Random().nextBool()),
                  );
                },
                // Builds 1000 ListTiles
                childCount: club.followers.length,
              ),
            )
          ]),
        ));
  }
}
