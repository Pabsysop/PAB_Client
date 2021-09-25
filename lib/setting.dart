import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/interestpage.dart';
import 'package:partyboard_client/widgets/switch_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class Setting extends StatelessWidget {
  String frequencyType = "Normal";
  bool trendingRoomInclude = false;
  bool pageNotifications = true;
  Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SETTINGS",
          style: TextStyle(fontSize: appBarTitleSize),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("Notifications",
                    style: TextStyle(color: Colors.grey[700])),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Frequency"),
                            Text(
                              frequencyType + " >",
                              style: TextStyle(color: Colors.grey[400]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    SwitchButton("Include Trending Rooms", trendingRoomInclude,
                        (b) => {print("Frequency change: " + b.toString())}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    SwitchButton("Page Notifications", pageNotifications,
                        (b) => {print("Frequency change: " + b.toString())}),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    buildButton1("Account", () {}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    buildButton1("Interest", () {
                      // print("Test Interest");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (b) => InterestPage()));
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    buildButton2("What's New", () {}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    buildButton2("FAQ / Contact Us", () {}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    buildButton2("Community Guidelines", () {}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    buildButton2("Terms of Service", () {}),
                    Divider(
                      height: 0,
                      thickness: 1.5,
                    ),
                    buildButton2("Privarcy Policy", () {}),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Center(
                        child: Text(
                          "Log out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  "version 0.1.5 (2090)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

buildButton1(title, onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(
            Icons.arrow_forward,
            size: 20,
            color: Colors.grey[400],
          )
        ],
      ),
    ),
  );
}

buildButton2(title, onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(
            FontAwesomeIcons.arrowUp,
            size: 20,
            color: Colors.grey[400],
          )
        ],
      ),
    ),
  );
}
