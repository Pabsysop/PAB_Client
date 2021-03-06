import 'dart:collection';
import 'dart:convert';
import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';

class AndersonMethod {
  static const talk = "Talk";
  static const openBoard = "CreateBoard";
  static const openRoom = "CreateRoom";
  static const myAvatar = "LookLike";
  static const upAvatar = "Makeup";
  static const myName = "WhatsYourName";
  static const about = "About";
  static const editAbout = "Record";
  static const myFollows = "Follows";
  static const like = "Like";
  static const follow = "Follow";
  static const listen = "Listen";
  static const speak = "Speak";
  static const leave = "Leave";
}

final andersonIdl = IDL.Service({
  AndersonMethod.talk: IDL.Func([IDL.Variant({"AboutBoards": IDL.Null,"AboutPeople": IDL.Null})], [IDL.Vec(IDL.Principal)], ['query']),
  AndersonMethod.openBoard: IDL.Func([], [IDL.Principal], ['update']),
  AndersonMethod.openRoom: IDL.Func([IDL.Text, IDL.Opt(IDL.Text)], [], ['update']),
  AndersonMethod.myAvatar: IDL.Func([], [IDL.Record({"id":IDL.Text, "src":IDL.Variant({"DFINITY": IDL.Null,"LOCAL": IDL.Null})})], ['query']),
  AndersonMethod.myName: IDL.Func([], [IDL.Text], ['query']),
  AndersonMethod.upAvatar: IDL.Func([IDL.Text, IDL.Variant({"DFINITY": IDL.Null,"LOCAL": IDL.Null})], [], ['update']),
  AndersonMethod.myFollows: IDL.Func([], [IDL.Vec(IDL.Tuple([IDL.Principal, IDL.Nat64])), IDL.Vec(IDL.Tuple([IDL.Principal, IDL.Nat64]))], ['query']),
  AndersonMethod.like: IDL.Func([], [], ['update']),
  AndersonMethod.about: IDL.Func([], [IDL.Vec(IDL.Nat8)], ['query']),
  AndersonMethod.editAbout: IDL.Func([IDL.Vec(IDL.Nat8)], [], ['update']),
  AndersonMethod.follow: IDL.Func([IDL.Principal], [], ['update']),
  AndersonMethod.listen: IDL.Func([IDL.Principal, IDL.Text], [IDL.Text], ['update']),
  AndersonMethod.speak: IDL.Func([IDL.Principal, IDL.Text], [], ['update']),
  AndersonMethod.leave: IDL.Func([IDL.Principal, IDL.Text], [], ['update']),
});

class Anderson extends ActorHook {
  Anderson();
  factory Anderson.create(CanisterActor _actor) {
    return Anderson()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<List<Principal>> talk() async {
    try {
      var res = await actor.getFunc(AndersonMethod.talk)!([{"AboutBoards": null}]);
      if (res != null) {
        return res as List<Principal>;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<Principal> openBoard() async {
    try {
      var res = await actor.getFunc(AndersonMethod.openBoard)!([]);
      if (res != null) {
        return res as Principal;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> openRoom(String title, {String cover = ""}) async {
    try {
      await actor.getFunc(AndersonMethod.openRoom)!([title,[cover]]);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<HashMap<String, String>> myAvatar() async {
    try {
      var res = await actor.getFunc(AndersonMethod.myAvatar)!([]);
      if (res != null) {
        HashMap<String, String> nft = new HashMap();
        nft["id"] = res["id"];
        nft["src"] = res["src"].keys.elementAt(0);
        return nft;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> myName() async {
    try {
      var res = await actor.getFunc(AndersonMethod.myName)!([]);
      if (res != null) {
        return res;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> about() async {
    try {
      var res = await actor.getFunc(AndersonMethod.about)!([]);
      if (res != null) {
        return res;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editAbout(String text) async {
    try {
      var intro = {"content_type": "intro", "content": text.runes.toList()};
      var bytes = jsonEncode(intro).codeUnits;
      await actor.getFunc(AndersonMethod.editAbout)!([bytes]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> upAvatar(String idx, String src) async {
    try {
      await actor.getFunc(AndersonMethod.upAvatar)!([idx,{src: null}]);
    } catch (e) {
      rethrow;
    }
  }

  Future<HashMap<String, List>> myFollows() async {
    try {
      var res = await actor.getFunc(AndersonMethod.myFollows)!([]);
      if (res != null) {
        var follows = new HashMap<String, List>();
        follows["follower"] = res[0];
        follows["following"] = res[1];
        return follows;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> like(Principal nouse) async {
    try {
      var res = await actor.getFunc(AndersonMethod.like)!([]);
      if (res != null) {
        return;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> listen(Principal board, String room) async {
    try {
      var res = await actor.getFunc(AndersonMethod.listen)!([board, room]);
      if (res != null) {
        return res;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> speak(Principal board, String room) async {
    try {
      await actor.getFunc(AndersonMethod.speak)!([board, room]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leave(Principal board, String room) async {
    try {
      await actor.getFunc(AndersonMethod.leave)!([board, room]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> follow(Principal followed) async {
    try {
      await actor.getFunc(AndersonMethod.follow)!([followed]);
    } catch (e) {
      rethrow;
    }
  }
}
