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

  void retrieveAvatarBytes(Identity ident){
    getAvatarBytes(ident).then((value){
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

  Uint8List getAvatar(){
    return this.avatarBytes ?? Uint8List(0);
  }

  String getName(){
    return name ?? "";
  }

  Future<Uint8List> getAvatarBytes(Identity ident) async{

    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    HashMap nftinfo = await _anderson!.myAvatar();
    String nftIdx = nftinfo["id"];
    String nftSrc = nftinfo["src"];

    var prefs = await SharedPreferences.getInstance();
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

  Future<void> openRoom(Identity ident) async{
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    await _anderson!.openRoom("anonymous room");
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
