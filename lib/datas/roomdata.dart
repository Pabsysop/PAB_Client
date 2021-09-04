import 'package:clubhouse_clone_ui_kit/datas/clubdatas.dart';
import 'package:clubhouse_clone_ui_kit/datas/usersdatas.dart';
import 'package:clubhouse_clone_ui_kit/model/room.dart';
import 'package:clubhouse_clone_ui_kit/model/user.dart';

List<Room> rooms = [
  Room(club1.name, "Meditation for healthy life", users: [
    user1,
    user2,
    user4,
    user8,
    user10,
  ], followedBySpeakers: [
    user5,
    user6,
    user7,
  ], otherUsers: [
    user9,
    user3,
  ]),
  Room(club2.name, "Important of science",
      users: [user3, user5, user2, user9],
      followedBySpeakers: [user1, user6, user7],
      otherUsers: [user4, user8, user10]),
  Room(club3.name, "Cartoon story telling",
      users: [user3, user5, user4, user9],
      followedBySpeakers: [user1, user6, user7],
      otherUsers: [user8, user10]),
  Room(club4.name, "Technology evolution",
      users: [user9, user3, user8],
      followedBySpeakers: [user1, user2],
      otherUsers: [user4, user5]),
  Room(club5.name, "Plant tree",
      users: [user2, user3, user9, user8],
      followedBySpeakers: [user1, user4],
      otherUsers: [user10, user9]),
];

List<User> followingUsers = [user3, user5, user9, user1, user6, user10];

List<User> followersUsers = [user2, user4, user6, user1];

List<User> tempUsers = [
  user1,
  user2,
  user3,
  user4,
  user5,
  user6,
  user7,
  user8,
  user9,
  user10,
];
