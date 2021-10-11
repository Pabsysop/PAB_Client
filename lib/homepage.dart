import 'dart:typed_data';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/conversationroom.dart';
import 'package:partyboard_client/model/crypto.dart';
import 'package:partyboard_client/profile_page.dart';
import 'package:partyboard_client/utils.dart';
import 'package:partyboard_client/widgets/room_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/club.dart';
import 'model/room.dart';
import 'model/user.dart';


// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);
  ValueNotifier reset = ValueNotifier(false);
  
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with ChangeNotifier{
  late Identity _identity;
  late User _myDigitalLife;
  List<Club> _clubs = [];
  List<Room> _rooms = [];
  Uint8List _avatarBytes = Uint8List(0);

  void getRooms(){
    _myDigitalLife.loadRoomList(_identity).then((value){
      setState(() {
        _clubs.addAll(value[0]);
        _rooms.addAll(value[1]);
      });
    });
    _myDigitalLife.retrieveFollows(_identity).then((value){
      for (var user in _myDigitalLife.following) {
        user.loadRoomList(_identity).then((value){
          setState(() {
            _clubs.addAll(value[0]);
            _rooms.addAll(value[1]);
          });
        });
      }
    });
  }

  @override
  void initState(){
    super.initState();

    getUserEnv();

    widget.reset.addListener(() {
      debugPrint("prefs got ok");

      getRooms();

      _myDigitalLife.getAvatarBytes(_identity).then((value){
        setState(() {
          _avatarBytes = value;
        });
      });
    });
  }

  String getClubnameById(Principal clubId){
    for (var club in _clubs) {
      if (club.boardId == clubId) {
        return club.title ?? "";
      }
    }
    return "";
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50 / 2.2)),
            child: Image.memory(_avatarBytes,
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.envelope_open),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CupertinoIcons.calendar),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: Colors.black,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () {
              return Future(() {
                Future.delayed(Duration(seconds: 4));
                getRooms();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  ..._rooms.map((r) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => ConversationRoom(r, getClubnameById(r.clubId))
                          )
                        );
                      },
                      child: RoomWidget(r, getClubnameById(r.clubId), _identity)
                    )
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment
                      .bottomCenter, // 10% of the width, so there are ten blinds.
                  colors: [
                    Color.fromRGBO(241, 240, 228, 0.1),
                    backgroundColor,
                  ], // red to yellow
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: size.width / 2 - 100,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[500],
                      onPrimary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      fixedSize: Size(200, 45),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          context: context,
                          builder: (context) {
                            return buildBottomModalSheet();
                          });
                    },
                    child: Text(
                      '+ Start a room',
                      style: TextStyle(fontSize: buttonFontSize),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Stack(
                    children: [
                      Icon(Icons.apps),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBottomModalSheet() {
    return BottomModalSheet();
  }
}

// ignore: must_be_immutable
class BottomModalSheet extends StatefulWidget {
  int bottomSelectionIndex = 1;
  BottomModalSheet({Key? key}) : super(key: key);

  @override
  _BottomModalSheetState createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(color: Colors.grey),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10),
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.green, elevation: 0),
              onPressed: () {},
              child: Text('choose a room type'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      widget.bottomSelectionIndex = 1;
                    });
                  },
                  child: Ink(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: widget.bottomSelectionIndex == 1
                              ? Colors.grey[400]
                              : Colors.transparent,
                          border: Border.all(
                              color: widget.bottomSelectionIndex == 1
                                  ? Colors.grey
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(70 / 2.2)),
                            child: Image.asset(
                              'assets/images/world.jpg',
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text("Open")
                        ],
                      ))),
              InkWell(
                  onTap: () {
                    setState(() {
                      widget.bottomSelectionIndex = 2;
                    });
                  },
                  child: Ink(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: widget.bottomSelectionIndex == 2
                              ? Colors.grey[400]
                              : Colors.transparent,
                          border: Border.all(
                              color: widget.bottomSelectionIndex == 2
                                  ? Colors.grey
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(70 / 2.2)),
                            child: Image.asset(
                              'assets/images/social.jpg',
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text("Ticket")
                        ],
                      ))),
              InkWell(
                  onTap: () {
                    setState(() {
                      widget.bottomSelectionIndex = 3;
                    });
                  },
                  child: Ink(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: widget.bottomSelectionIndex == 3
                              ? Colors.grey[400]
                              : Colors.transparent,
                          border: Border.all(
                              color: widget.bottomSelectionIndex == 3
                                  ? Colors.grey
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(70 / 2.2)),
                            child: Image.asset(
                              'assets/images/lock.jpg',
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text("Private")
                        ],
                      )))
            ],
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 20,
            thickness: 1,
          ),
          SizedBox(
            height: 20,
          ),
          // RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(children: <TextSpan>[
          //     TextSpan(
          //         text: "Start a room",
          //         style: TextStyle(color: Colors.black54)),
          //     TextSpan(
          //       text: " open to everyone",
          //       style: TextStyle(color: Colors.black),
          //     )
          //   ]),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green[800],
              onPrimary: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: Size(100, 40), //////// HERE
            ),
            onPressed: () async{
              var pop = showProgress(context, "openning room");
              var user = await User.newUser(null);
              var ident = await Crypto.getIdentity();
              await user.openRoom(ident);
              pop.dismiss();
              Navigator.pop(context);
            },
            child: Text(
              "🎉 Let's go",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
