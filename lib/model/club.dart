import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/ICP/agent_factory.dart';
import 'package:partyboard_client/ICP/board.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/model/room.dart';
import 'package:partyboard_client/model/user.dart';

class Club {
  Principal boardId;
  List<User> followers = [];
  Board? _boardClient;
  String? title;
  String? about;
  String? cover;

  Club(this.boardId);

  static Club newClub(Principal boardId) {
    return Club(boardId);
  }

  Future<List<Room>> myMeta(Identity? ident) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    var res = await _boardClient!.hi();
    List<String> boardMeta = res[0];
    this.title = boardMeta[0];
    this.cover = boardMeta[1];
    this.about = boardMeta[2];

    List<Room> rooms = [];
    for (var r in res[1]) {
        Room room = Room(r["id"], r["title"], r["cover"], r["owner"], boardId);
        room.moderators.addAll(r["moderators"]);
        room.speakers.addAll(r["speakers"]);
        room.audiens.addAll(r["audiens"]);
        rooms.add(room);
    }

    return rooms;
  }

  Future<String> joinRoom(Identity? ident, String roomId) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    return await _boardClient!.joinRoom(roomId);
  }

  Future<void> leaveRoom(Identity? ident, String roomId) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    await _boardClient!.leaveRoom(roomId);
  }

  Future<void> deleteRoom(Identity? ident, String roomId) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    await _boardClient!.deleteRoom(roomId);
  }

  Future<String> editRoom(Identity? ident, String roomId, String title, String desc) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    return await _boardClient!.editRoom(title, desc, roomId);
  }

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
