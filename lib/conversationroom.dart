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

  @override
  void initState() {
    super.initState();

    widget.reset.addListener(() {
      debugPrint("prefs got ok");

      for (var user in widget.room.speakersUsers) {
        listenFor(user, _speakers);
        user.retrieveAvatarBytes(_identity);
        user.retrieveName(_identity);
      }
      for (var user in widget.room.audiensUsers) {
        listenFor(user, _audiens);
        user.retrieveAvatarBytes(_identity);
        user.retrieveName(_identity);
      }

      var owner = RoomUser(User(widget.room.owner), widget.room.owner.toText());
      owner.user.myName(_identity).then((name){
        owner.user.name = name;
        _owner = owner;
        setState(() {
          _boardTitle = widget.room.title + " - " + name;
          _appBarTitle = name + '\'s Board';
          listenFor(_owner.user, _speakers);
          _owner.user.retrieveAvatarBytes(_identity);
        });
      });

      initialize();

    });

    getUserEnv();

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

  Future<void> initialize() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    var channelName = sha256.convert(utf8.encode(widget.room.id+widget.room.clubId.toText())).toString();
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
    if (_myDigitalLife.digitalLifeId == widget.room.owner){
      await _engine.setClientRole(ClientRole.Broadcaster);
      _role = "publisher";
    } else if(widget.room.speakers.contains(_myDigitalLife.digitalLifeId)){
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
          if( ua.userAccount  != widget.room.owner.toText()){
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
                          onPressed: () => {},
                          icon: Icon(CupertinoIcons.ellipsis))
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
            onTap: () {
              _engine.leaveChannel();
              _engine.destroy();
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
