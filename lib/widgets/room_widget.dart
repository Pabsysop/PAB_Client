import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/model/club.dart';
import 'package:partyboard_client/model/room.dart';
import 'package:partyboard_client/model/user.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomWidget extends StatefulWidget {
  final Room room;
  final Club club;
  final Identity _identity;

  RoomWidget(this.room, this.club, this._identity, {Key? key}) : super(key: key);

  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> with ChangeNotifier {
  List<User> _audiens = [];
  List<User> _speakers = [];
  String _boardTitle = "";


  void listenFor(User user, List<User> belongTo){
    user.addListener(() {
      setState(() {
        belongTo.add(user);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    for (var user in widget.room.speakersUsers) {
      listenFor(user, _speakers);
      user.retrieveAvatarBytes(widget._identity);
    }
    for (var user in widget.room.audiensUsers) {
      listenFor(user, _audiens);
      user.retrieveName(widget._identity);
    }
    User.newUser(widget.room.owner).then((user){
      user.myName(widget._identity).then((name){
        setState(() {
          _boardTitle = name + '\'s Board';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_boardTitle + " 🏡"),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.room.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.room.cover,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    child: Stack(
                      children: [
                        ..._speakers.map((u) =>
                          Positioned(
                              left: 1,
                              top: 5,
                              child: MemoryImageWidget(u.getAvatar(), 30)
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._audiens.map((u) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    u.getName(),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  CupertinoIcons.chat_bubble,
                                  size: 15,
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "0",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: 15,
                            ),
                            Text(
                              " / ",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              "0",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Icon(
                              Icons.chat,
                              color: Colors.grey[600],
                              size: 15,
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
