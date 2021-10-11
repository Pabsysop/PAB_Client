import 'dart:collection';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/followers_page.dart';
import 'package:partyboard_client/following_page.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import 'clubwidget.dart';
import 'model/crypto.dart';
import 'model/user.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget{
  ProfilePage({Key? key}) : super(key: key);
  ValueNotifier reset = ValueNotifier(false);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ChangeNotifier{
  late Identity _identity;
  late User _myDigitalLife;
  Uint8List _avatarBytes = Uint8List(0);
  String _myName = "";
  HashMap<String, Uint8List> userAvatarBytes = new HashMap();
  HashMap<String, String> usersName = new HashMap();

  @override
  void initState(){
    super.initState();

    getUserEnv();

    widget.reset.addListener(() {
      debugPrint("prefs got ok");

      _myDigitalLife.getAvatarBytes(_identity).then((value){
        setState(() {
          userAvatarBytes[_myDigitalLife.digitalLifeId.toText()] = value;
          _avatarBytes = value;
        });
      });

      _myDigitalLife.myName(_identity).then((value){
        setState(() {
          _myName = value;
          usersName[_myDigitalLife.digitalLifeId.toText()] = value;
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
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(150 / 2.2)),
                    child: Image.memory(_avatarBytes,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("nick:" + _myName),
                        SizedBox(
                          height: 10,
                        ),
                        Text("id: " + _myDigitalLife.digitalLifeId.toText()),
                        SizedBox(
                          height: 10,
                        ),
                        Text("[incentives]"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text("likes: 10PAB" ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Minings: 10PAB"),
                            ]
                          )
                        )
                      ]
                    )
                  )
                ]
              ),
              SizedBox(
                height: 40,
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
                        child: Text(
                            _myDigitalLife.followers.length.toString() + " Followers")),
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
                        child: Text((_myDigitalLife.followingClub.length +
                                    _myDigitalLife.following.length)
                                .toString() +
                            " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowingPage(
                                _myDigitalLife.following, _myDigitalLife.followingClub,
                                userAvatarBytes, usersName
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
              Text("Description: " + no_description_hint),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Boards"),
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
                                              _myDigitalLife.followingClub[index], true,
                                              _myDigitalLife.followingClub[index].followers
                                          )
                                      )
                                  );
                                },
                                child: index < _myDigitalLife.followingClub.length
                                    ? ProfileImageWidget(
                                        clubImage3, 40)
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
                      itemCount: _myDigitalLife.followingClub.length + 1,
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
