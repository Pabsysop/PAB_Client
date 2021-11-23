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
      user.retrieveAvatarBytes(widget._identity);
      // user.retrieveName(widget._identity);
    }
    User.newUser(widget.room.owner).then((user){
      widget.room.speakersUsers.add(user);
      listenFor(user, _speakers);
      user.retrieveAvatarBytes(widget._identity);
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 40,
                    child: Stack(
                      children: [
                        ..._speakers
                        .sublist(0, _speakers.length > 2 ? 2 : _speakers.length)
                        .asMap().entries.map((entry) {
                            return Positioned(
                                left: 1 + entry.key*20,
                                top: 5,
                                child: MemoryImageWidget(entry.value.getAvatar(), 30)
                            );
                          }
                        ),
                        ..._audiens.sublist(0, _audiens.length > 3 ? 3 : _audiens.length).asMap().entries.map((entry){
                            var idx = entry.key + _speakers.length > 2 ? 2 : _speakers.length - 1;
                            return Positioned(
                                left: 1 + idx*20,
                                top: 5,
                                child: MemoryImageWidget(entry.value.getAvatar(), 30)
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 3,
                //   child:Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [ ..._audiens.map((u) => 
                //       Flexible(
                //         child: Text(
                //           u.getName(),
                //         ),
                //       ),
                //     )]
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  (_audiens.length + _speakers.length).toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 15,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
