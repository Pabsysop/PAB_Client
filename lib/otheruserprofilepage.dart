import 'package:partyboard_client/clubwidget.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constant.dart';
import 'followers_page.dart';
import 'following_page.dart';
import 'model/user.dart';

// ignore: must_be_immutable
class OtherUserProfilePage extends StatefulWidget {
  final User user;
  bool isFollow = false;

  OtherUserProfilePage(this.user, {Key? key, this.isFollow = false})
      : super(key: key);

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            elevation: 5,
            icon: Icon(Icons.more_vert),
            onSelected: (s) => {},
            itemBuilder: (BuildContext context) {
              return {'Share Profile...', 'Block', 'Report an incident'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileImageWidget(widget.user.image, 60),
                  Spacer(),
                  Visibility(
                      visible: widget.isFollow,
                      child: InkWell(
                        child: Container(
                            padding: EdgeInsets.all(2.8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: deepBlue, width: 1.5)),
                            child: Icon(
                              CupertinoIcons.bell,
                              size: 20,
                              color: deepBlue,
                            )),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  FollowButton(
                    widget.isFollow,
                    onTap: (b) => {
                      setState(() {
                        widget.isFollow = b;
                      })
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.all(2.8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: deepBlue, width: 1.5)),
                        child: Icon(
                          CupertinoIcons.bell,
                          size: 20,
                          color: deepBlue,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.user.name,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                widget.user.id,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FollowersPage(widget.user.followers)),
                          );
                        },
                        child: Text(widget.user.followers.length.toString() +
                            " Followers")),
                    flex: 1,
                  ),
                  // SizedBox(
                  //   width: 45,
                  // ),
                  Expanded(
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Text((widget.user.following.length +
                                    widget.user.followingClub.length)
                                .toString() +
                            " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FollowingPage(
                                    widget.user.following,
                                    widget.user.followingClub)),
                          );
                        }),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              if (widget.user.about.isNotEmpty) Text(widget.user.about),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.only(left: 0),
                            primary: buttonPrimary,
                            elevation: 0),
                        onPressed: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.twitter,
                              size: 15,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(widget.user.twiterId ??
                                widget.user.twiterId.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.only(left: 0),
                            primary: buttonPrimary,
                            elevation: 0),
                        onPressed: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.instagram,
                              size: 15,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(widget.user.instaId ??
                                widget.user.instaId.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (widget.user.nominee != null)
                Row(
                  children: [
                    ProfileImageWidget(widget.user.nominee!.image, 40),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Joined Feb 24, 2021"),
                        RichText(
                          text: TextSpan(
                            text: 'Nominated by ',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.user.nominee!.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              SizedBox(
                height: 40,
              ),
              if (widget.user.followingClub.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Memeber of"),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ClubWidget(
                                              widget.user.followingClub[index],
                                              true)));
                                },
                                child: ProfileImageWidget(
                                    widget.user.followingClub[index].image,
                                    30)),
                          );
                        },
                        itemCount: widget.user.followingClub.length,
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
