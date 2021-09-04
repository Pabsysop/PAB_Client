import 'package:agent_dart/agent_dart.dart';

import 'init.dart';

class NaisMethod {
  static const apply_citizen = "ApplyCitizenship";
  static const count = "getValue";
}

final idl = IDL.Service({
  NaisMethod.count: IDL.Func([], [IDL.Nat], ['query']),
  NaisMethod.apply_citizen: IDL.Func([], [], []),
});

class Counter extends ActorHook {
  Counter();
  factory Counter.create(CanisterActor _actor) {
    return Counter()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<int> count() async {
    try {
      var res = await actor.getFunc(NaisMethod.count)!([]);
      if (res != null) {
        return (res as BigInt).toInt();
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add() async {
    try {
      await actor.getFunc(NaisMethod.apply_citizen)!([]);
    } catch (e) {
      rethrow;
    }
  }
}
