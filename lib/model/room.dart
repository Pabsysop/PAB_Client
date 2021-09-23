import 'package:clubhouse_clone_ui_kit/model/user.dart';

class Room {
  final String clubName;
  final String topic;
  final List<User> users;
  final List<User> followedBySpeakers;
  final List<User> otherUsers;

  const Room(this.clubName, this.topic,
      {required this.users,
      required this.followedBySpeakers,
      required this.otherUsers});
}
