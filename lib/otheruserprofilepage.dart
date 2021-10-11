import 'dart:collection';
import 'dart:typed_data';
import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/clubwidget.dart';
import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'followers_page.dart';
import 'following_page.dart';
import 'model/crypto.dart';
import 'model/user.dart';

// ignore: must_be_immutable
class OtherUserProfilePage extends StatefulWidget {
  final User userProfile;
  OtherUserProfilePage(this.userProfile, {Key? key}) : super(key: key);
  ValueNotifier reset = ValueNotifier(false);

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> with ChangeNotifier{
  late Identity _identity;
  Uint8List _avatarBytes = Uint8List(0);
  bool isFollow = true;
  HashMap<String, Uint8List> userAvatarBytes = new HashMap();
  HashMap<String, String> usersName = new HashMap();

  @override
  void initState(){
    super.initState();

    getUserEnv();

    widget.reset.addListener(() {
      widget.userProfile.getAvatarBytes(_identity).then((value){
        setState(() {
          _avatarBytes = value;
        });
      });
    });
  }

  void getUserEnv() {
    Crypto.getIdentity().then((ident){
      setState(() {
        _identity = ident;
        widget.reset.notifyListeners();
      });
    });
  }

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
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(150 / 2.2)),
                    child: Image.memory(_avatarBytes,
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("nick:" + widget.userProfile.getName()),
                        SizedBox(
                          height: 10,
                        ),
                        Text("id: " + widget.userProfile.digitalLifeId.toText()),
                        SizedBox(
                          height: 10,
                        ),
                        FollowButton(
                          isFollow,
                          onTap: (b) => {
                            setState(() {
                              isFollow = b;
                            })
                          },
                        ),
                      ]
                    )
                  )
                ]
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 25,
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
                                    FollowersPage(widget.userProfile.followers)),
                          );
                        },
                        child: Text(widget.userProfile.followers.length.toString() +
                            " Followers")),
                    flex: 1,
                  ),
                  Expanded(
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Text((widget.userProfile.following.length +
                                    widget.userProfile.followingClub.length)
                                .toString() +
                            " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowingPage(
                                  widget.userProfile.following,
                                  widget.userProfile.followingClub,
                                  userAvatarBytes,
                                  usersName
                              )
                            ),
                          );
                        }),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              if (widget.userProfile.followingClub.isNotEmpty)
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
                                              widget.userProfile.followingClub[index],
                                              true,
                                              widget.userProfile.followingClub[index].followers
                                          )
                                      )
                                  );
                                },
                                child: ProfileImageWidget(
                                    clubImage4,
                                    30)),
                          );
                        },
                        itemCount: widget.userProfile.followingClub.length,
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
