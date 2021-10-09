import 'dart:typed_data';
import 'package:partyboard_client/otheruserprofilepage.dart';
import 'package:partyboard_client/widgets/memory_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/roomuser.dart';

class RoomUserWidget extends StatelessWidget {
  final RoomUser user;
  const RoomUserWidget(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => OtherUserProfilePage()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              MemoryImageWidget(
                user.user.avatarBytes ?? Uint8List(0),
                60,
              ),
              if (user.isNew)
                Positioned(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black38)]),
                    child: Text(
                      '🎉',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  left: 0,
                  bottom: 0,
                ),
              if (user.isMute)
                Positioned(
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black38)]),
                      child: Icon(
                        FontAwesomeIcons.microphoneSlash,
                        size: 19,
                      )),
                  right: 0,
                  bottom: 0,
                )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            (user.isOwner ? '✳️ ' : " ") + (user.user.name ?? ""),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
