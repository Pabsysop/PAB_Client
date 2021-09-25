import 'package:partyboard_client/model/user.dart';

class Club {
  String name;
  String image;
  String about;
  List<User> followers = [];

  Club(this.name, this.image, {this.about = '', List<User>? followerList})
      : this.followers = followerList ?? [];

  setFollowers(List<User> followers) {
    this.followers = followers;
  }

  addFollowers(User user) {
    followers.add(user);
  }

  removeFollowers(User user) {
    followers.remove(user);
  }
}
