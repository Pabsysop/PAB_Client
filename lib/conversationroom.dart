import 'dart:convert';
import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/model/room.dart';
import 'package:partyboard_client/model/roomuser.dart';
import 'package:partyboard_client/profile_page.dart';
import 'package:partyboard_client/roomuserwidget.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypto/crypto.dart';
import 'constant.dart';
import 'model/crypto.dart';
import 'model/user.dart';

const appId = "c2a463d954a8439196fffbbae156b8f1";
const token = "";

// ignore: must_be_immutable
class ConversationRoom extends StatefulWidget {
  final Room inRoom;
  ValueNotifier reset = ValueNotifier(false);

  ConversationRoom(this.inRoom);

  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> with ChangeNotifier {
  late RtcEngine _engine;
  late Room room;
  late Identity _identity;
  late User _myDigitalLife;
  late List<RoomUser> _users;
  late String clubName;

  @override
  void initState() {
    super.initState();

    room = widget.inRoom;

    widget.reset.addListener(() {
      debugPrint("prefs got ok");
      initialize();
    });
  }

 @override
 void dispose() {
  //  _users.clear();
  //  _engine.leaveChannel();
  //  _engine.destroy();
   super.dispose();
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

    await _initAgoraRtcEngine();

    _engine.registerLocalUserAccount(appId, _myDigitalLife.digitalLifeId.toText());

    _addAgoraEventHandlers();

    var channelName = sha256.convert(utf8.encode(room.id+room.clubId.toText())).toString();
    await _engine.joinChannelWithUserAccount(token, channelName, _myDigitalLife.digitalLifeId.toText());
  }
  
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    if (_myDigitalLife.digitalLifeId == room.owner){
      await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else if(room.speakers.contains(_myDigitalLife.digitalLifeId)){
      await _engine.setClientRole(ClientRole.Broadcaster);
    }else{
      await _engine.setClientRole(ClientRole.Audience);
    }
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          print('onError: $code');
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannel: $channel, uid: $uid');
        RoomUser u = RoomUser(User(Principal.fromText(uid as String)), uid as String);
        u.user.addListener(() {
          setState(() {
            _users.add(u);
          });
        });
        u.user.retrieveAvatarBytes(_identity);
        u.user.retrieveName(_identity);
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined: $uid');
        RoomUser u = RoomUser(User(Principal.fromText(uid as String)), uid as String);
        u.user.addListener(() {
          setState(() {
            _users.add(u);
          });
        });
        u.user.retrieveAvatarBytes(_identity);
        u.user.retrieveName(_identity);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: TextButton.icon(
            onPressed: () => {Navigator.pop(context)},
            style: TextButton.styleFrom(primary: Colors.black),
            icon: Icon(CupertinoIcons.chevron_down),
            label: Text("Hallway")),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.doc)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
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
                      Text(clubName.toUpperCase() + ' 🏡',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                      IconButton(
                          onPressed: () => {},
                          icon: Icon(CupertinoIcons.ellipsis))
                    ],
                  ),
                  Text(
                    room.title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: bodyFontSize, fontWeight: FontWeight.bold),
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
                  ..._users.map((e) => RoomUserWidget(e))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Followed by the speakers",
                style: TextStyle(fontSize: 14, color: Colors.grey[350]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ...room.speakers.map((e) => RoomUserWidget(RoomUser(User(e), e.toText())))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Others in the room",
                style: TextStyle(fontSize: 14, color: Colors.grey[350]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                children: [
                  ...room.audiens.map((e) => RoomUserWidget(RoomUser(User(e), e.toText())))
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
            onTap: () {},
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
              child: Icon(CupertinoIcons.add),
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
