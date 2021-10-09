import 'dart:typed_data';
import 'package:partyboard_client/model/room.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final Room room;
  final String clubName;
  final List<Uint8List> usersAvatarBytes;
  final List<String> usersName;
  const RoomWidget(this.room, this.clubName, this.usersAvatarBytes, this.usersName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(clubName + " 🏡"),
            SizedBox(
              height: 5,
            ),
            Text(
              room.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
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
                        Positioned(
                            left: 28,
                            top: 28,
                            child: MemoryImageWidget(usersAvatarBytes[0], 50)),
                        Positioned(
                            left: 0,
                            top: 0,
                            child: MemoryImageWidget(usersAvatarBytes[1], 50)),
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
                        ...usersName.take(5).map((name) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
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
                              "208",
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
                              "32",
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
