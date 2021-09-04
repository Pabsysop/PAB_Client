import 'package:clubhouse_clone_ui_kit/model/user.dart';

class RoomUser {
  final User user;
  bool isMute;
  bool isNew;
  bool isOwner;
  RoomUser(this.user,
      {this.isMute = false, this.isNew = true, this.isOwner = false});
}
