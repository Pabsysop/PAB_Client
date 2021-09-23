import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:clubhouse_clone_ui_kit/constant.dart';
import 'package:clubhouse_clone_ui_kit/followers_page.dart';
import 'package:clubhouse_clone_ui_kit/following_page.dart';
import 'package:clubhouse_clone_ui_kit/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:pem/pem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clubwidget.dart';
import 'datas/usersdatas.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Identity? _identity;
  Principal? _myLife;
  String _myAvatar = "not nft avatar";

  void getUserEnv() {
    SharedPreferences.getInstance().then((prefs) {
      String? lifeId = prefs.getString("lifeCanisterID");
      if (lifeId != null) {
        setState(() {
          _myLife = Principal.fromText(lifeId);
        });
      }
      String? pKey = prefs.getString("pKey");
      if (pKey != null) {
        var pkBytes = PemCodec(PemLabel.privateKey).decode(pKey);
        setState(() {
          _identity = Ed25519KeyIdentity.fromSecretKey(Uint8List.fromList(pkBytes));
        });
      }
      return;
    });
  }

  @override
  void initState(){
    super.initState();
    getUserEnv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(150 / 2.2)),
                child: Image.asset(
                  "assets/images/avatar-3.jpg",
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("PAB#1"),
              SizedBox(
                height: 2,
              ),
              Text(_myLife == null ? "" : _myLife.toString()),
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
              Text(no_description_hint),
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
                            text: 'Invited by ',
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
                  Text("Member of"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
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
