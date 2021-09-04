import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ICP/canister_caller.dart';
import 'homepage.dart';
import 'constant.dart';

class CodePage extends StatelessWidget {
  const CodePage({Key? key}) : super(key: key);

  void callIcpBorn(){
      CanisterCaller caller = CanisterCaller();
      caller.initCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "输入你的密码",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: headingFontSize),
              ),
              Column(
                children: [
                  Container(
                    child: IntrinsicWidth(
                      child: TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 4,
                        style: TextStyle(letterSpacing: 2, fontSize: 15),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "****",
                          contentPadding: EdgeInsets.symmetric(horizontal: 100),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          counterText: "",
                          filled: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: IntrinsicWidth(
                      child: TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 4,
                        style: TextStyle(letterSpacing: 2, fontSize: 15),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "confirm",
                          contentPadding: EdgeInsets.symmetric(horizontal: 100),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          counterText: "",
                          filled: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonPrimary,
                  onPrimary: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(150, 50), //////// HERE
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (c) => Scaffold(body: Homepage())),
                  );
                },
                child: Text(
                  'Gotcha ->',
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
