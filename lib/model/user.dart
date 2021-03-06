import 'dart:collection';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:flutter/material.dart';
import 'package:partyboard_client/ICP/agent_factory.dart';
import 'package:partyboard_client/ICP/anderson.dart';
import 'package:partyboard_client/ICP/avatar_nft.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/model/room.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../constant.dart';
import 'club.dart';

class User with ChangeNotifier {
  Principal digitalLifeId;
  Anderson? _anderson;
  Uint8List? avatarBytes;
  String? name;

  List<User> followers = [];
  List<User> following = [];
  List<Club> followingClub = [];

  User(this.digitalLifeId);
  
  static Future<User> newUser(Principal? lifeId) async {
    if (lifeId == null) {
      var prefs =  await SharedPreferences.getInstance();
      lifeId = Principal.fromText(prefs.getString(lifePrefsKey) ?? "");
    }
    return User(lifeId);
  }

  void retrieveAvatarBytes(Identity ident, { bool other = true }){
    getAvatarBytes(ident, other).then((value){
      avatarBytes = value;
      notifyListeners();
    });
  }

  Future<void> retrieveFollows(Identity ident) async{
    var follows = await myFollows(ident);
    for (var f in follows["follower"] ?? []) {
      var u = User(f[0]);
      followers.add(u);
    }
    for (var f in follows["following"] ?? []) {
      var u = User(f[0]);
      following.add(u);
    }
  }

  void retrieveName(Identity ident){
    myName(ident).then((value){
      name = value;
      notifyListeners();
    });
  }

  void retrieveIntro(Identity ident){
    myName(ident).then((value){
      name = value;
      notifyListeners();
    });
  }

  Uint8List getAvatar(){
    return this.avatarBytes ?? Uint8List(0);
  }

  String getName(){
    return name ?? "";
  }

  Future<Uint8List> getAvatarBytes(Identity ident, bool other) async{
    var prefs = await SharedPreferences.getInstance();
    var nftIdx = prefs.getString(avatarIdxPrefsKey);
    var nftSrc = prefs.getString(avatarSrcPrefsKey);

    if (nftIdx == null || other){
      if (_anderson == null){
        _anderson = NaisAgentFactory.create(
              canisterId: digitalLifeId.toText(),
              url: replicaUrl,
              idl: andersonIdl,
              identity: ident,
        ).hook(Anderson());
      }
      HashMap nftinfo = await _anderson!.myAvatar();
      nftIdx = nftinfo["id"];
      nftSrc = nftinfo["src"];
    }
    if (nftSrc == "LOCAL" && nftIdx != null){
      var aBytes = await rootBundle.load(nftIdx);
      return aBytes.buffer.asUint8List();
    }
    if (nftSrc == "DFINITY" && nftIdx != null){
      String? avatarCanisterId = prefs.getString(avatarPrefsKey);
      if (avatarCanisterId == null || avatarCanisterId.isEmpty) {
        var nais = NaisAgentFactory.create(
              canisterId: naisCanisterId,
              url: replicaUrl,
              idl: naisIdl,
              identity: ident,
        ).hook(Nais());
        var hi = await nais.hi();
        avatarCanisterId = hi.split(';').elementAt(hi.split(';').length - 2).trim();
        prefs.setString(avatarPrefsKey, avatarCanisterId);
      }
      var nft = NaisAgentFactory.create(
            canisterId: avatarCanisterId.trim(),
            url: replicaUrl,
            idl: nftIdl,
            identity: ident,
      ).hook(NFTCanister());
      var payload = await nft.tokenByIndex(nftIdx);
      return payload;
    }
    throw Exception("no avatar found");
  }

  void getRoomUserProfile(List<Room> rooms, Identity ident){
    for (Room room in rooms){
      for (var userid in room.speakers) {
        var user = User(userid);
        user.retrieveAvatarBytes(ident);
        user.retrieveName(ident);
        room.speakersUsers.add(user);
      }
      for (var userid in room.audiens) {
        var user = User(userid);
        user.retrieveAvatarBytes(ident);
        user.retrieveName(ident);
        room.audiensUsers.add(user);
      }
    }
  }

  Future<List> loadRoomList(Identity ident) async{
    List<Room> userRooms = [];
    List<Club> userClubs = [];

    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }

    var boards = await _anderson!.talk();
    for (var board in boards) {
      var club = Club.newClub(board);
      var rooms = await club.myMeta(ident);
      userRooms.addAll(rooms);
      userClubs.add(club);
      getRoomUserProfile(rooms, ident);
    }
    
    return [userClubs, userRooms];
  }

  Future<void> openRoom(Identity ident, String title, String desc) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.openRoom(title, cover: desc);
  }

  Future<void> follow(Identity ident, Principal followed) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.follow(followed);
  }

  Future<String> myName(Identity? ident) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    return await _anderson!.myName();
  }

  Future<String> about(Identity? ident) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    return await _anderson!.about();
  }

  Future<void> editAbout(Identity? ident, String intro) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.editAbout(intro);
  }

  Future<void> speak(Identity? ident, Principal board, String room) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.speak(board, room);
  }
  Future<void> listen(Identity? ident, Principal board, String room) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.listen(board, room);
  }
  Future<void> leave(Identity? ident, Principal board, String room) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.leave(board, room);
  }

  Future<HashMap<String, List>> myFollows(Identity? ident) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    return await _anderson!.myFollows();
  }

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
