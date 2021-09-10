import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';

enum WasmType {
    PABToken,
    Board,
    Life,
    AvatarNFT,
    VisaNFT
} 

final String naisCanisterId = "rrkah-fqaaa-aaaaa-aaaaq-cai";
final String replicaUrl = "http://192.168.4.192:8000";

class NaisMethod {
  static const apply_citizen = "ApplyCitizenship";
  static const upload_wasm = "uploadWasm";
}

Map<String, Object> wasmArg = {"wasm_type": WasmType.VisaNFT, "wasm_module": []};

final naisIdl = IDL.Service({
  NaisMethod.apply_citizen: IDL.Func([IDL.Text], [IDL.Opt(IDL.Principal)], ['update']),
  NaisMethod.upload_wasm: IDL.Func([IDL.Record(wasmArg)], [], ['update']),
});

class Nais extends ActorHook {
  Nais();
  factory Nais.create(CanisterActor _actor) {
    return Nais()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<Principal> applyCitizen(String code) async {
    try {
      var res = await actor.getFunc(NaisMethod.apply_citizen)!([code]);
      if (res != null) {
        return res as Principal;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> makeAvatarNFT(WasmType wtype, List<int> executable) async {
    try {
      wasmArg["wasm_module"] = executable;
      await actor.getFunc(NaisMethod.upload_wasm)!([wasmArg]);
    } catch (e) {
      rethrow;
    }
  }

}
