import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';

class AndersonMethod {
  static const talk = "Talk";
  static const openBoard = "CreateBoard";
  static const openRoom = "CreateRoom";
  static const myAvatar = "LookLike";
  static const upAvatar = "Makeup";
  static const myName = "WhatsYourName";
}

final andersonIdl = IDL.Service({
  AndersonMethod.talk: IDL.Func([IDL.Variant({"AboutBoards": IDL.Null,"AboutPeople": IDL.Null})], [IDL.Vec(IDL.Principal)], ['query']),
  AndersonMethod.openBoard: IDL.Func([], [IDL.Principal], ['update']),
  AndersonMethod.openRoom: IDL.Func([IDL.Text, IDL.Opt(IDL.Text)], [], ['update']),
  AndersonMethod.myAvatar: IDL.Func([], [IDL.Text], ['query']),
  AndersonMethod.myName: IDL.Func([], [IDL.Text], ['query']),
  AndersonMethod.upAvatar: IDL.Func([IDL.Text], [], ['update']),
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

  Future<void> openRoom(String title, String? cover) async {
    try {
      var res = await actor.getFunc(AndersonMethod.openRoom)!([title,]);
      if (res != null) {
        return;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }
  
  Future<String> myAvatar() async {
    try {
      var res = await actor.getFunc(AndersonMethod.myAvatar)!([]);
      if (res != null) {
        return res;
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

  Future<void> upAvatar(String idx) async {
    try {
      var res = await actor.getFunc(AndersonMethod.upAvatar)!([idx,]);
      if (res != null) {
        return;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

}
