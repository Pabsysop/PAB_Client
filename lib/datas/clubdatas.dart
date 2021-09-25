import 'package:partyboard_client/datas/imagesaddress.dart';
import 'package:partyboard_client/datas/usersdatas.dart';
import 'package:partyboard_client/model/club.dart';

List<Club> followingClubs = [];

var club1 = Club("Meditate Club", clubImage1,
    about:
        "focus one's mind for a period of time, in silence or with the aid of chanting, for religious or spiritual purposes or as a method of relaxation",
    followerList: [user1, user3, user5, user6, user8, user9]);
var club2 = Club("Science and technology", clubImage2, about: "");
var club3 = Club("Story telling", clubImage3,
    about:
        "Storytelling describes the social and cultural activity of sharing stories, sometimes with improvisation, theatrics or embellishment",
    followerList: []);

var club4 = Club("New technology", clubImage4, about: "", followerList: []);
var club5 = Club("United World", clubImage5, about: "", followerList: []);
var club6 = Club("Path of success", clubImage6, about: "", followerList: []);
var club7 =
    Club("Money earn platform", clubImage7, about: "", followerList: []);
