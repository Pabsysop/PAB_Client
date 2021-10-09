import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';


class BoardMethod {
  static const hi = "Hi";
}

final boardIdl = IDL.Service({
  BoardMethod.hi: IDL.Func([], [IDL.Vec(IDL.Text), IDL.Vec(IDL.Principal)], ['query']),
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

}
