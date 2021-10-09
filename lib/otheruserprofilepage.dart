import 'dart:collection';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/clubwidget.dart';
import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constant.dart';
import 'followers_page.dart';
import 'following_page.dart';
import 'model/crypto.dart';
import 'model/user.dart';

// ignore: must_be_immutable
class OtherUserProfilePage extends StatefulWidget {
  OtherUserProfilePage({Key? key}) : super(key: key);
  ValueNotifier reset = ValueNotifier(false);

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> with ChangeNotifier{
  late Identity _identity;
  late User _myDigitalLife;
  bool isFollow = true;
  HashMap<String, Uint8List> userAvatarBytes = new HashMap();
  HashMap<String, String> usersName = new HashMap();

  @override
  void initState(){
    super.initState();
    getUserEnv();

    widget.reset.addListener(() {
      debugPrint("prefs got ok");
      _myDigitalLife.loadRoomList(_identity).then((value){
        var all = _myDigitalLife.followers;
        all.addAll(_myDigitalLife.following);
          for (var user in all) {
            user.addListener(() {
              setState(() {
                userAvatarBytes[user.digitalLifeId.toText()] = user.getAvatar();
                usersName[user.digitalLifeId.toText()] = user.getName();
              });
            });
            user.retrieveAvatarBytes(_identity);
            user.retrieveName(_identity);
          }
      });
      _myDigitalLife.getAvatarBytes(_identity).then((value){
        setState(() {
          userAvatarBytes[_myDigitalLife.digitalLifeId.toText()] = value;
        });
      });
    });
  }

  void getUserEnv() {
    Crypto.getIdentity().then((ident){

      setState(() {
        _identity = ident;
      });

      User.newUser(null).then((me) {
        setState(() {
          _myDigitalLife = me;
        });
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MemoryImageWidget(_myDigitalLife.getAvatar(), 60),
                  Spacer(),
                  Visibility(
                      visible: isFollow,
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
                    isFollow,
                    onTap: (b) => {
                      setState(() {
                        isFollow = b;
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
                _myDigitalLife.getName(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                _myDigitalLife.digitalLifeId.toText(),
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
                                    FollowersPage(_myDigitalLife.followers)),
                          );
                        },
                        child: Text(_myDigitalLife.followers.length.toString() +
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
                        child: Text((_myDigitalLife.following.length +
                                    _myDigitalLife.followingClub.length)
                                .toString() +
                            " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowingPage(
                                  _myDigitalLife.following,
                                  _myDigitalLife.followingClub,
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
              if (_myDigitalLife.followingClub.isNotEmpty)
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
                                              _myDigitalLife.followingClub[index],
                                              true,
                                              usersName,
                                              userAvatarBytes
                                          )
                                      )
                                  );
                                },
                                child: ProfileImageWidget(
                                    clubImage4,
                                    30)),
                          );
                        },
                        itemCount: _myDigitalLife.followingClub.length,
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
