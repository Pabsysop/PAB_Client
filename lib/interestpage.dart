import 'package:partyboard_client/datas/interestDatas.dart';
import 'package:partyboard_client/widgets/interestitemwidget.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class InterestPage extends StatelessWidget {
  const InterestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INTEREST"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Text(
                        "Add more interest so we can begin to personalize Clubhouse for you. interest are private to you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text("⏱ Tech"),
                    SizedBox(
                      height: 5,
                    ),
                    buildInterestChips(techData),
                    Text("⏱ Identity"),
                    SizedBox(
                      height: 5,
                    ),
                    buildInterestChips(techData),
                    Text("⏱ Identity"),
                    SizedBox(
                      height: 5,
                    ),
                    buildInterestChips(techData),
                    Text("⏱ Identity"),
                    SizedBox(
                      height: 5,
                    ),
                    buildInterestChips(techData)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment
                        .bottomCenter, // 10% of the width, so there are ten blinds.
                    colors: [
                      Color.fromRGBO(241, 240, 228, 0.1),
                      backgroundColor,
                    ], // red to yellow
                    tileMode: TileMode
                        .repeated, // repeats the gradient over the canvas
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildInterestChips(List<List<String>> datas) {
    return Container(
      height: 150,
      child: ListView(
          // physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...datas.map((listItem) {
                  return Row(
                    children: [
                      ...listItem.map((e) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: 8.0, bottom: 10),
                          child: InterestItemWidget(e),
                        );
                      })
                    ],
                  );
                })
              ],
            ),
          ]),
    );
  }
}
