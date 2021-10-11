import 'dart:typed_data';

import 'package:draw_your_image/draw_your_image.dart';
import 'package:flutter/material.dart';

class MyDrawPage extends StatefulWidget {
  @override
  _MyDrawPageState createState() => _MyDrawPageState();
}

class _MyDrawPageState extends State<MyDrawPage> {
  var _currentColor = Colors.black;
  var _currentWidth = 4.0;
  final _controller = DrawController();
  Uint8List _imageData = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRAW WHAT YOU WANT!'),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              _controller.convertToImage();
            },
            child: new Text(
              "Save",
              style: TextStyle(color: Colors.green, fontSize: 15, )
            )
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Draw(
                  controller: _controller,
                  backgroundColor: Colors.yellow.shade50,
                  strokeColor: _currentColor,
                  strokeWidth: _currentWidth,
                  isErasing: false,
                  onConvertImage: (imageData) {
                    setState(() {
                      _imageData = imageData;
                    });
                    Navigator.pop(context, _imageData);
                  }                
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              children: [
                Colors.black,
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.yellow
              ].map(
                (color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentColor = color;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: color,
                        child: Center(
                          child: _currentColor == color
                              ? Icon(
                                  Icons.brush,
                                  color: Colors.white,
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 32),
            Slider(
              max: 40,
              min: 1,
              value: _currentWidth,
              onChanged: (value) {
                setState(() {
                  _currentWidth = value;
                });
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}