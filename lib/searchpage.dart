import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/datas/roomdata.dart';
import 'package:partyboard_client/widgets/button.dart';
import 'package:partyboard_client/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import 'otheruserprofilepage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("EXPLORE"),
          bottom: PreferredSize(
            preferredSize: Size(30, 30),
            child: Container(
              padding: EdgeInsets.all(8),
              height: 40,
              width: size.width - 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(0, 0, 0, 0.1)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: deepBlue,
                        style: TextStyle(fontSize: 17),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 11),
                          hintText: "Find People and Clubs",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PEOPLE TO FOLLOW",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    OtherUserProfilePage(tempUsers[index])));
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: ProfileImageWidget(tempUsers[index].image, 40),
                      title: Text(
                        tempUsers[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        tempUsers[index].about,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: FollowButton(false),
                    );
                  },
                  itemCount: tempUsers.length,
                ),
              )
            ],
          ),
        ));
  }
}
