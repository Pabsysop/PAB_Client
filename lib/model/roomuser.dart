import 'package:partyboard_client/model/user.dart';

class RoomUser {
  final User user;
  bool isMute;
  bool isNew;
  bool isOwner;
  String voiceId;
  RoomUser(this.user, this.voiceId,
      {this.isMute = false, this.isNew = true, this.isOwner = false});
}
