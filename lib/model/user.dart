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
    var nftIdx = await _anderson!.myAvatar();

    var prefs = await SharedPreferences.getInstance();
    String? avatarCanisterId = prefs.getString(avatarPrefsKey);
    if (avatarCanisterId == null) {
      var nais = NaisAgentFactory.create(
            canisterId: naisCanisterId,
            url: replicaUrl,
            idl: naisIdl,
            identity: ident,
      ).hook(Nais());
      var hi = await nais.hi();
      avatarCanisterId = hi.split(';').last;
      prefs.setString(avatarPrefsKey, avatarCanisterId);
    }
    var nft = NaisAgentFactory.create(
          canisterId: avatarCanisterId,
          url: replicaUrl,
          idl: nftIdl,
          identity: ident,
    ).hook(NFTCanister());
    var nftInfo = await nft.tokenByIndex(nftIdx);
    return nftInfo["payload"]!["Complete"];
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

    _anderson!.talk().then((boards) {
      for (var board in boards) {
        var club = Club.newClub(board);
        club.myMeta(ident).then((rs){
          List<Room> rooms = [];
          for (var r in rs) {
              Room room = Room(r.id, r.title, r.owner, board);
              room.moderators.addAll(r.moderators);
              room.speakers.addAll(r.speakers);
              room.audiens.addAll(r.audiens);
              room.cover = club.cover;
              rooms.add(room);
          }
          userRooms.addAll(rooms);
        });
        userClubs.add(club);
      }
    });
    return [userClubs, userRooms];
  }

  void openRoom(Identity ident){
    if (_anderson == null){
      _anderson = NaisAgentFactory.create(
            canisterId: digitalLifeId.toText(),
            url: replicaUrl,
            idl: andersonIdl,
            identity: ident,
      ).hook(Anderson());
    }
    _anderson!.openRoom("anonymous room", null);
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
