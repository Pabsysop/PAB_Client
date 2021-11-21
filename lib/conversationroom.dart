import 'dart:async';
import 'dart:convert';
import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/model/agora_token.dart';
import 'package:partyboard_client/model/room.dart';
import 'package:partyboard_client/model/roomuser.dart';
import 'package:partyboard_client/otheruserprofilepage.dart';
import 'package:partyboard_client/roomuserwidget.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypto/crypto.dart';
import 'model/club.dart';
import 'model/crypto.dart';
import 'model/user.dart';

const appId = "c2a463d954a8439196fffbbae156b8f1";

// ignore: must_be_immutable
class ConversationRoom extends StatefulWidget {
  final Room room;
  final Club club;

  ValueNotifier reset = ValueNotifier(false);
  ValueNotifier reset2 = ValueNotifier(false);

  ConversationRoom(this.room, this.club, {Key? key}) : super(key: key);

  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> with ChangeNotifier {
  late RtcEngine _engine;
  late Identity _identity;
  late User _myDigitalLife;
  late RoomUser _owner;
  List<RoomUser> _users = [];
  List<RoomUser> _audiens = [];
  List<RoomUser> _speakers = [];
  String _appBarTitle = "";
  String _boardTitle = "";
  String _role = "subscriber";
  bool _isSpeaker = false;
  late Room currentRoom;
  late Club currentClub;

  void listenFor(User user, List<RoomUser> belongTo){
    var ru = RoomUser(user, user.digitalLifeId.toText());
    user.addListener(() {
      setState(() {
        if(user.name != null && user.avatarBytes != null){
          belongTo.firstWhere(
            (u) => u.user.digitalLifeId == user.digitalLifeId,
            orElse: (){belongTo.add(ru);return ru;}
          );
        }
      });
    });
  }

  void listenRoomUpdate(Room room){
    room.addListener(() {
      room.allowsUsers.clear();
      room.speakersUsers.clear();
      _speakers.clear();
      _audiens.clear();
      for (var userid in room.speakers) {
        var user = User(userid);
        listenFor(user, _speakers);
        user.retrieveAvatarBytes(_identity);
        user.retrieveName(_identity);
        room.speakersUsers.add(user);
      }
      for (var userid in room.audiens) {
        var user = User(userid);
        listenFor(user, _audiens);
        user.retrieveAvatarBytes(_identity);
        user.retrieveName(_identity);
        room.audiensUsers.add(user);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    currentRoom = widget.room;
    currentClub = widget.club;

    widget.reset2.addListener(() {
      var owner = RoomUser(User(currentRoom.owner), currentRoom.owner.toText());
      owner.user.myName(_identity).then((name){
        owner.user.name = name;
        _owner = owner;
        setState(() {
          _boardTitle = currentRoom.title + " - " + name;
          _appBarTitle = name + '\'s Board';
          listenFor(_owner.user, _speakers);
          _owner.user.retrieveAvatarBytes(_identity);
        });
      });
      initialize();
    });

    getUserEnv();
    
    Timer.periodic(Duration(seconds: 40), (Timer timer) {
      currentClub.myMeta(_identity).then((rooms){
        var index = rooms.indexWhere((room) => room.id == currentRoom.id);
        setState(() {
            currentRoom.audiens = rooms[index].audiens;
            currentRoom.speakers = rooms[index].speakers;
        });
        currentRoom.notifyListeners();
      });
    });
  }

  void getUserEnv() {
    Crypto.getIdentity().then((ident){
      setState(() {
        _identity = ident;
      });

      listenRoomUpdate(currentRoom);

      User.newUser(null).then((me) {
        setState(() {
          _myDigitalLife = me;
          if (me.digitalLifeId == currentRoom.owner){
            me.speak(ident, currentClub.boardId, currentRoom.id).then((value){
              currentClub.myMeta(ident).then((rooms){
                var index = rooms.indexWhere((room) => room.id == currentRoom.id);
                setState(() {
                  currentRoom.audiens = rooms[index].audiens;
                  currentRoom.speakers = rooms[index].speakers;
                });
                currentRoom.notifyListeners();
              });
            });
          }else{
            me.listen(ident, currentClub.boardId, currentRoom.id).then((value){
              currentClub.myMeta(ident).then((rooms){
                var index = rooms.indexWhere((room) => room.id == currentRoom.id);
                setState(() {
                  currentRoom.audiens = rooms[index].audiens;
                  currentRoom.speakers = rooms[index].speakers;
                });
                currentRoom.notifyListeners();
              });
            });
          }
        });
        widget.reset2.notifyListeners();
      });
    });
  }

  Future<void> initialize() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    var channelName = sha256.convert(utf8.encode(currentRoom.id+currentRoom.clubId.toText())).toString();
    await _initAgoraRtcEngine();
    _engine.registerLocalUserAccount(appId, _myDigitalLife.digitalLifeId.toText());
    _addAgoraEventHandlers();
    var token = await AgoraToken.fetchRTCToken(_myDigitalLife.digitalLifeId.toText(), channelName, _role);
    await _engine.joinChannelWithUserAccount(token.rtcToken, channelName, _myDigitalLife.digitalLifeId.toText());
  }
  
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (_myDigitalLife.digitalLifeId == currentRoom.owner){
      await _engine.setClientRole(ClientRole.Broadcaster);
      _role = "publisher";
    } else if(currentRoom.speakers.contains(_myDigitalLife.digitalLifeId)){
      await _engine.setClientRole(ClientRole.Broadcaster);
      _role = "publisher";
    }else{
      await _engine.setClientRole(ClientRole.Audience);
    }
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        print('onError: $code');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannel: $channel, uid: $uid');
        _engine.getUserInfoByUid(uid).then((ua){
          if( ua.userAccount  != currentRoom.owner.toText()){
            var user = User(Principal.fromText(ua.userAccount));
            user.myName(_identity).then((name){
              user.name = name;
              listenFor(user, _audiens);
              user.retrieveAvatarBytes(_identity, other: false);
            });
          }
        });
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined: $uid');
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: SingleChildScrollView(scrollDirection:Axis.horizontal, child: TextButton.icon(
            onPressed: () => {Navigator.pop(context)},
            style: TextButton.styleFrom(primary: Colors.black),
            icon: Icon(CupertinoIcons.chevron_down),
            label: Text(_appBarTitle)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtherUserProfilePage(_users[0].user)),
                );
              },
              icon: ProfileImageWidget(clubImage1, 30)),
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
                      Text(_boardTitle + ' 🏡',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                      IconButton(
                          onPressed: () => {
                              currentClub.myMeta(_identity).then((rooms){
                                var index = rooms.indexWhere((room) => room.id == currentRoom.id);
                                setState(() {
                                    currentRoom.audiens = rooms[index].audiens;
                                    currentRoom.speakers = rooms[index].speakers;
                                });
                                currentRoom.notifyListeners();
                              })
                          },
                          icon: Icon(CupertinoIcons.refresh)
                        )
                    ],
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
                  ..._speakers.map((e) => RoomUserWidget(e))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "audiens",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ..._audiens.map((u) => RoomUserWidget(u))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Others in the room",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ..._users.map((u) => RoomUserWidget(u))
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
            onTap: () async {
              _engine.leaveChannel();
              _engine.destroy();
              await _myDigitalLife.leave(_identity, currentClub.boardId, currentRoom.id);
              Navigator.of(context).pop();
            },
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
              child: Icon(CupertinoIcons.hand_thumbsup),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.grey[200],
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () async {
              if( _isSpeaker ){
                await _engine.setClientRole(ClientRole.Audience);
                await _myDigitalLife.listen(_identity, currentClub.boardId, currentRoom.id).then((value){
                  currentClub.myMeta(_identity).then((rooms){
                    var index = rooms.indexWhere((room) => room.id == currentRoom.id);
                    setState(() {
                        currentRoom.audiens = rooms[index].audiens;
                        currentRoom.speakers = rooms[index].speakers;
                    });
                    currentRoom.notifyListeners();
                  });
               });
              }else{
                await _engine.setClientRole(ClientRole.Broadcaster);
                await _myDigitalLife.speak(_identity, currentClub.boardId, currentRoom.id).then((value){
                  currentClub.myMeta(_identity).then((rooms){
                    var index = rooms.indexWhere((room) => room.id == currentRoom.id);
                    setState(() {
                        currentRoom.audiens = rooms[index].audiens;
                        currentRoom.speakers = rooms[index].speakers;
                    });
                    currentRoom.notifyListeners();
                  });
               });
              }
              setState(() {
                _isSpeaker = !_isSpeaker;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: _isSpeaker ? Icon(CupertinoIcons.speaker_1_fill) : Icon(CupertinoIcons.hand_raised),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.grey[200],
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          )
        ],
      ),
    );
  }
}
