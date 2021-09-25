import 'package:partyboard_client/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InterestItemWidget extends StatefulWidget {
  bool isSelected = false;
  String text;
  InterestItemWidget(this.text, {Key? key, this.isSelected = false})
      : super(key: key);

  @override
  _InterestItemWidgetState createState() => _InterestItemWidgetState();
}

class _InterestItemWidgetState extends State<InterestItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected ? deepBlue : Colors.white,
            border: Border.all(color: Colors.grey)),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              color: widget.isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
