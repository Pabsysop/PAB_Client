import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hud/flutter_hud.dart';

import 'constant.dart';

PopupHUD showProgress(BuildContext context, String title){
  final popup = PopupHUD(
    context,
    hud: HUD(
      label: title,
      detailLabel: 'waiting...',
    ),
  );
  popup.show();
  return popup;
}

void getDefaultAvatar(){
  rootBundle.load(defaultAvatar).then((contents){
    contents.buffer.asUint8List();
  });
}

Future<void> showTipsDialog(BuildContext context, String tips1, String tips2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Partyboard'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(tips1),
              Text(tips2),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('知道了'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 3), () {
    Navigator.pop(context); //pop dialog
  });
}

TextEditingController _roomTitleEditFieldController = TextEditingController();
TextEditingController _roomDescEditFieldController = TextEditingController();
Future<dynamic> roomEditDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('please input room title'),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                TextField(
                  controller: _roomTitleEditFieldController,
                  decoration: InputDecoration(hintText: "title"),
                ),
                TextField(
                  controller: _roomDescEditFieldController,
                  decoration: InputDecoration(hintText: "description"),
                )
            ]
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
                Navigator.pop(context, [_roomTitleEditFieldController.text, _roomDescEditFieldController.text]);
              },
            ),
          ],
        );
      },
    );
  }
  