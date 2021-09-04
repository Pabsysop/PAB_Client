import 'club.dart';

class User {
  String image;
  String name;
  String id;
  String about;
  String? instaId;
  String? twiterId;
  User? nominee;

  List<User> followers = [];
  List<User> following = [];
  List<Club> followingClub = [];

  User(this.image, this.name,
      {this.nominee,
      this.about: "",
      this.id: '',
      this.instaId,
      this.twiterId,
      List<User>? followersList,
      List<User>? followingList,
      List<Club>? followingClubList})
      : this.followers = followersList ?? [],
        this.following = followingList ?? [],
        this.followingClub = followingClubList ?? [];

  void setFollowers(List<User> followers) {
    this.followers = followers;
  }

  void setFollowing(List<User> following) {
    this.following = following;
  }

  void addFollowing(User user) {
    following.add(user);
  }

  void setFollowingClub(List<Club> followingClub) {
    this.followingClub = followingClub;
  }

  void addFollowingClub(Club club) {
    followingClub.add(club);
  }

  void addFollower(User user) {
    followers.add(user);
  }

  void removeFollowing(User user) {
    following.remove(user);
  }

  void removeFollower(User user) {
    followers.remove(user);
  }
}
