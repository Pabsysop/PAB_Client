import 'package:partyboard_client/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SwitchButton extends StatefulWidget {
  String title;
  bool switchValue;

  Function onChange;
  SwitchButton(this.title, this.switchValue, this.onChange, {Key? key})
      : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.switchValue = !widget.switchValue;
        });
        widget.onChange(widget.switchValue);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            Switch(
                activeColor: deepBlue,
                value: widget.switchValue,
                onChanged: (b) {
                  setState(() {
                    widget.switchValue = b;
                  });

                  widget.onChange(b);
                })
          ],
        ),
      ),
    );
  }
}
