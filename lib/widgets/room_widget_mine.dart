import 'package:partyboard_client/model/room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyRoomWidget extends StatefulWidget {
  final Room room;
  final String clubName;

  MyRoomWidget(this.room, this.clubName, {Key? key}) : super(key: key);

  @override
  _MyRoomWidgetState createState() => _MyRoomWidgetState();
}

class _MyRoomWidgetState extends State<MyRoomWidget> with ChangeNotifier {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
                Text("🏡"),
                Text(
                  widget.room.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.room.cover,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
