import 'package:clubhouse_clone_ui_kit/constant.dart';
import 'package:clubhouse_clone_ui_kit/followers_page.dart';
import 'package:clubhouse_clone_ui_kit/following_page.dart';
import 'package:clubhouse_clone_ui_kit/setting.dart';
import 'package:clubhouse_clone_ui_kit/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'clubwidget.dart';
import 'datas/usersdatas.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.login)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageWidget(user10.image, 60),
              SizedBox(
                height: 15,
              ),
              Text(user10.name),
              SizedBox(
                height: 2,
              ),
              Text(user10.id),
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
                                    FollowersPage(user10.followers)),
                          );
                        },
                        child: Text(
                            user10.followers.length.toString() + " Followers")),
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
                        child: Text((user10.followingClub.length +
                                    user10.following.length)
                                .toString() +
                            " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FollowingPage(
                                    user10.following, user10.followingClub)),
                          );
                        }),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              if (user10.about.isNotEmpty) Text(user10.about),
              SizedBox(
                height: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.only(left: 0),
                    primary: buttonPrimary,
                    elevation: 0),
                onPressed: () {},
                child: Text('Add a bio'),
              ),
              SizedBox(
                height: 0,
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
                            Text(user10.twiterId ?? user10.twiterId.toString()),
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
                            Text(user10.instaId ?? user10.instaId.toString()),
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
              if (user10.nominee != null)
                Row(
                  children: [
                    ProfileImageWidget(user10.nominee!.image, 40),
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
                                  text: user10.nominee!.name,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Memeber of"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // print("club size: " +
                        //     currentUser.followingClub.length.toString());
                        return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ClubWidget(
                                              user10.followingClub[index],
                                              true)));
                                },
                                child: index < user10.followingClub.length
                                    ? ProfileImageWidget(
                                        user10.followingClub[index].image, 40)
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey[300],
                                        ),
                                        child: IconButton(
                                            onPressed: () {},
                                            iconSize: 10,
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            )),
                                      )));
                      },
                      itemCount: user10.followingClub.length + 1,
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
