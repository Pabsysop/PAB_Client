import 'dart:typed_data';

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
final String replicaUrl = "http://192.168.1.79:8000";

class NaisMethod {
  static const apply_citizen = "ApplyCitizenship";
  static const make_avatar_nft = "RequestAvatarNft";
}

final naisIdl = IDL.Service({
  NaisMethod.apply_citizen: IDL.Func([IDL.Text], [IDL.Opt(IDL.Principal)], ['update']),
  NaisMethod.make_avatar_nft: IDL.Func([IDL.Record({"image_bytes": IDL.Vec(IDL.Nat8)})], [IDL.Text], ['update']),
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
        return res[0] as Principal;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> makeAvatarNFT(Uint8List imageBytes) async {
    try {
      Map<String, List<dynamic>> imageArg = {"image_bytes": imageBytes};
      var res = await actor.getFunc(NaisMethod.make_avatar_nft)!([imageArg]);
      if (res != null) {
        return res[0] as String;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

}
