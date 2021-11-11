import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/followers_page.dart';
import 'package:partyboard_client/following_page.dart';
import 'package:partyboard_client/otheruserprofilepage.dart';
import 'package:partyboard_client/utils.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:partyboard_client/widgets/room_widget_mine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ICP/agent_factory.dart';
import 'ICP/anderson.dart';
import 'ICP/nais.dart';
import 'avatars_page.dart';
import 'draw_example.dart';
import 'model/club.dart';
import 'model/crypto.dart';
import 'model/room.dart';
import 'model/user.dart';
import 'utils.dart';

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
  String _avatarDesc = "not NFT Avatar";
  String _defaultAvatar = "assets/images/avatar-1.jpg";
  String _myName = "";
  String _myDesc = "";
  HashMap<String, Uint8List> userAvatarBytes = new HashMap();
  HashMap<String, String> usersName = new HashMap();
  List<User> _followings = [];
  List<User> _followers = [];
  List<Room> _rooms = [];

  void getRooms(){
    _myDigitalLife.loadRoomList(_identity).then((value){
      setState(() {
        _rooms.addAll(value[1]);
      });
    });
  }
  void listenFor(User user, List<User> belongTo){
    user.addListener(() {
      setState(() {
        belongTo.add(user);
      });
    });
  }

  @override
  void initState(){
    super.initState();

    getUserEnv();

    widget.reset.addListener(() {
      debugPrint("prefs got ok");

      _myDigitalLife.getAvatarBytes(_identity, false).then((value){
        setState(() {
          userAvatarBytes[_myDigitalLife.digitalLifeId.toText()] = value;
          _avatarBytes = value;
        });

        SharedPreferences.getInstance().then((prefs){
          var nftIdx = prefs.getString(avatarIdxPrefsKey);
          var nftSrc = prefs.getString(avatarSrcPrefsKey);
          if (nftSrc == "DFINITY" && nftIdx != null){
            setState(() {
              _avatarDesc = "NFT Avatar #" + nftIdx;
            });
          }
        });
      });

      getRooms();

      _myDigitalLife.myName(_identity).then((value){
        setState(() {
          _myName = value;
          usersName[_myDigitalLife.digitalLifeId.toText()] = value;
        });
      });

      _myDigitalLife.about(_identity).then((value){
        setState(() {
          _myDesc = value;
        });
      });

      _myDigitalLife.retrieveFollows(_identity).then((value){
        for (var user in _myDigitalLife.followers) {
          listenFor(user, _followers);
          user.retrieveAvatarBytes(_identity);
        }
        for (var user in _myDigitalLife.following) {
          listenFor(user, _followings);
          user.retrieveAvatarBytes(_identity);
        }
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

  void setImageBytes(){
    rootBundle.load(_defaultAvatar).then(
      (contents){
        setState(() {
          _avatarBytes = contents.buffer.asUint8List();
        });
    });
  }

  Future<void> upAvatar(String id, String src) {
    var anderson = NaisAgentFactory.create(
          canisterId: _myDigitalLife.digitalLifeId.toText(),
          url: replicaUrl,
          idl: andersonIdl,
          identity: _identity,
    ).hook(Anderson());
    return anderson.upAvatar(id, src);
  }

  Future<void> requestAvatarNFT(Uint8List contents, BuildContext context) async{
      var nais = NaisAgentFactory.create(
            canisterId: naisCanisterId,
            url: replicaUrl,
            idl: naisIdl,
            identity: _identity,
      ).hook(Nais());

      var pop = showProgress(context, "upload nft data");
      var avatarIdx = await nais.makeAvatarNFT(contents);
      await upAvatar(avatarIdx, "DFINITY");
      setState(() {
        _avatarDesc = "NFT Avatar #" + avatarIdx;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(avatarIdxPrefsKey, avatarIdx);
      prefs.setString(avatarSrcPrefsKey, "DFINITY");
      pop.dismiss();
  }

  void _openFileExplorer(BuildContext context) async {
    try {
      var paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: null,
      ))?.files;
      var fd = File(paths!.single.path!);
      var contents = await fd.readAsBytes();

      await requestAvatarNFT(contents, context);

      setState(() {
        _avatarBytes = contents;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
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
                  Column(
                    children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(150 / 2.2)),
                          child: Image.memory(_avatarBytes,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(_avatarDesc),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              iconSize: 20.0,
                              icon: Icon(Icons.search),
                              onPressed: () async{
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AvatarsPage()),
                                );
                                if (result != null){
                                  setState(() {
                                    _defaultAvatar = result;
                                  });
                                  setImageBytes();
                                  await upAvatar(_defaultAvatar, "LOCAL");
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString(avatarIdxPrefsKey, _defaultAvatar);
                                  prefs.setString(avatarSrcPrefsKey, "LOCAL");
                                }
                              }
                            ),
                            IconButton(
                              iconSize: 20.0,
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final bytes = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyDrawPage()),
                                );
                                if (bytes != null){
                                  setState(() {
                                    _avatarBytes = bytes;
                                  });
                                  await requestAvatarNFT(bytes, context);
                                }
                              }
                            ),
                            IconButton(
                              iconSize: 20.0,
                              icon: Icon(Icons.upload),
                              onPressed: (){
                                _openFileExplorer(context);
                              }
                            ),
                          ],
                        ),
                    ],
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                              Text("minings: 10PAB"),
                            ]
                          )
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: (){
                            Clipboard.setData(new ClipboardData(text: _myDigitalLife.digitalLifeId.toText())).then((_){
                              ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Code Copied')));
                            });                            
                          },
                          child: Text(_myDigitalLife.digitalLifeId.toText())
                        ),
                      ]
                    )
                  )
                ]
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Description: " + no_description_hint),
                  IconButton(
                    iconSize: 20.0,
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      _editMyIntroDialog(context, _myDigitalLife, _identity).then((value){
                          _myDigitalLife.about(_identity).then((value){
                            setState(() {
                              _myDesc = value;
                            });
                          });                        
                      });
                    }
                  ),
                ],
              ),
              Text(_myDesc),
              SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Text(_followers.length.toString() + " Followers"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowersPage(_followers)
                            ),
                          );
                        }),
                    flex: 0,
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
                                          builder: (_) => OtherUserProfilePage(
                                              _myDigitalLife.followers[index]
                                          )
                                      )
                                  );
                                },
                                child: MemoryImageWidget(_myDigitalLife.avatarBytes??Uint8List(0), 40)
                            )
                        );
                      },
                      itemCount: _followers.length,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Text(_followings.length.toString() + " Following"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowingPage(
                                _followings, _myDigitalLife.followingClub,
                              )
                            ),
                          );
                        }),
                    flex: 0,
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
                                          builder: (_) => OtherUserProfilePage(
                                              _followings[index]
                                          )
                                      )
                                  );
                                },
                                child: index < _followings.length
                                    ? MemoryImageWidget(_followings[index].avatarBytes??Uint8List(0), 40)
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey[300],
                                        ),
                                        child: IconButton(
                                            onPressed: () {
                                              _inputFollowedDialog(context, _myDigitalLife, _identity);
                                            },
                                            iconSize: 10,
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            )),
                                      )));
                      },
                      itemCount: _followings.length + 1,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Board Rooms"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () {
                                  _editOrDeleteDialog(context, _rooms[index], _identity);
                                },
                                child: MyRoomWidget(_rooms[index], "")
                            )
                        );
                      },
                      itemCount: _rooms.length,
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

TextEditingController _textFieldController = TextEditingController();

Future<void> _inputFollowedDialog(BuildContext context, User me, Identity identity) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('please input citizen code'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "citizen code"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                me.follow(identity, Principal.fromText(_textFieldController.text)).then((v) => Navigator.pop(context));
              },
            ),
          ],
        );
      },
    );
  }

TextEditingController _myIntroEditFieldController = TextEditingController();
Future<void> _editMyIntroDialog(BuildContext context, User me, Identity identity) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('about me less than 30 charactors'),
          content: TextField(
            controller: _myIntroEditFieldController,
            decoration: InputDecoration(hintText: ""),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                me.editAbout(identity, _myIntroEditFieldController.text).then(
                  (v) => Navigator.pop(context)
                );
              },
            ),
          ],
        );
      },
    );
  }

Future<void> _editOrDeleteDialog(BuildContext context, Room room, Identity identity ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('choose action'),
          content: TextField(
            decoration: InputDecoration(hintText: ""),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Club.newClub(room.clubId).deleteRoom(identity, room.id).then((value) => Navigator.pop(context));
              },
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                roomEditDialog(context)
                .then((value){
                  var txt = value as List<String>; 
                  Club.newClub(room.clubId)
                  .editRoom(identity, room.id, txt[0], txt[1])
                  .then((v) => Navigator.pop(context));
                });
              },
            ),
          ],
        );
      },
    );
  }
