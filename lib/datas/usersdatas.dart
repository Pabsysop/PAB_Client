import 'package:partyboard_client/model/user.dart';

import 'clubdatas.dart';
import 'imagesaddress.dart';

var user1 = User(personImage1, "Sara Walt",
    id: '@sara12',
    instaId: 'sara123',
    twiterId: 'sara12',
    followersList: [user6, user3, user4],
    followingList: [user7, user4, user6],
    followingClubList: [club3, club2, club4]);
var user2 = User(personImage2, "Natasha John",
    id: '@john3',
    instaId: 'john',
    twiterId: 'john9',
    about:
        "In publishing and graphic design, Lorem ipsum is a placeholder text commonly",
    followersList: [user7, user9, user3, user4],
    followingClubList: [],
    followingList: [user3, user4, user9]);
var user3 = User(personImage3, "Benjamin",
    id: '@benjamin', instaId: 'benjamin3', twiterId: 'benjamin2');
var user4 = User(personImage4, "Isabella",
    id: '@isabella9', instaId: 'isabella2', twiterId: 'isabella2');
var user5 = User(personImage5, "William",
    id: '@william8', instaId: 'william3', twiterId: 'william2');
var user6 = User(personImage6, "Sophia",
    id: '@sophia', instaId: 'sophia3', twiterId: 'sophia2');
var user7 = User(personImage7, "Harper",
    id: '@harper43', instaId: 'harper2', twiterId: 'harper3');
var user8 = User(personImage8, "Noah",
    id: '@noah90', instaId: 'noah2', twiterId: 'noah9');
var user9 = User(personImage9, "James",
    id: '@james1', instaId: 'james3', twiterId: 'james5');
var user10 = User(personImage10, "Olivia",
    id: '@olivia122',
    instaId: 'olivia6',
    twiterId: 'olivia7',
    about:
        'I am a wild photographer my interest is taking animals photo i love my professional',
    followersList: [],
    followingClubList: [],
    followingList: [user1]);
