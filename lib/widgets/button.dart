import 'package:clubhouse_clone_ui_kit/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FollowButton extends StatefulWidget {
  bool isFollow;
  Function? onTap;
  FollowButton(this.isFollow, {this.onTap, Key? key}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with AutomaticKeepAliveClientMixin {
  String title = "Follow";

  Color fontColor = deepBlue;
  Color filledColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    changeState();
  }

  void changeState() {
    if (widget.isFollow) {
      title = "Following";
      fontColor = Colors.white;
      filledColor = deepBlue;
    } else {
      title = "Follow";
      fontColor = deepBlue;
      filledColor = Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        setState(() {
          widget.isFollow = !widget.isFollow;
          changeState();
          widget.onTap?.call(widget.isFollow);
        });
      },
      child: Container(
        child: Text(
          title,
          style: TextStyle(color: fontColor),
        ),
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: filledColor,
            border: Border.all(
              color: deepBlue,
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
