import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';


class BoardMethod {
  static const hi = "Hi";
  static const joinRoom = "JoinRoom";
  static const leaveRoom = "LeaveRoom";
}

 Map<String, dynamic> roomType = 
{
   "id": IDL.Text,
   "title": IDL.Text,
   "cover": IDL.Text,
   "owner": IDL.Principal,
   "allows": IDL.Vec(IDL.Principal),
   "moderators": IDL.Vec(IDL.Principal),
   "speakers": IDL.Vec(IDL.Principal),
   "audiens": IDL.Vec(IDL.Principal),
   "fee": IDL.Float64,
 };

final boardIdl = IDL.Service({
  BoardMethod.hi: IDL.Func([], [IDL.Vec(IDL.Text), IDL.Vec(IDL.Record(roomType))], ['query']),
  BoardMethod.joinRoom: IDL.Func([IDL.Opt(IDL.Text), IDL.Text], [IDL.Text], ['update']),
  BoardMethod.leaveRoom: IDL.Func([IDL.Text], [], ['update']),
});

class Board extends ActorHook {
  Board();
  factory Board.create(CanisterActor _actor) {
    return Board()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<List> hi() async {
    try {
      var res = await actor.getFunc(BoardMethod.hi)!([]);
      if (res != null) {
        return res;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> joinRoom(String roomId) async {
    try {
      var res = await actor.getFunc(BoardMethod.joinRoom)!([null, roomId]);
      if (res != null) {
        return res;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      await actor.getFunc(BoardMethod.leaveRoom)!([roomId]);
    } catch (e) {
      rethrow;
    }
  }
}
