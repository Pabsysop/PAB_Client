import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';


class NFTMethod {
  static const tokenByIndex = "tokenByIndex";
}

Map<String, CType<dynamic>> errParam = 
 {
   "AuthorizedPrincipalLimitReached": IDL.Nat,
   "Immutable": IDL.Null,
   "InvalidRequest": IDL.Null,
   "NotFound": IDL.Null,
   "Unauthorized": IDL.Null,
 };
 Map<String, dynamic>  chunk = 
 {
   "data": IDL.Vec(IDL.Nat8),
   "nextPage": IDL.Opt(IDL.Nat),
   "totalPages": IDL.Nat
 };
 Map<String, CType<dynamic>> payloadResult = 
 {
   "Chunk": IDL.Record(chunk),
   "Complete": IDL.Vec(IDL.Nat8)
 };
 Map<String, CType<dynamic>>  value = 
{
   "Bool": IDL.Bool,
   "Empty": IDL.Empty,
   "Float": IDL.Float64,
   "Int": IDL.Int32,
   "Nat": IDL.Nat,
   "Principal": IDL.Principal,
   "Text": IDL.Text
 };
 Map<String, dynamic> property =
{
   "immutable": IDL.Bool,
   "name": IDL.Text,
   "value": IDL.Variant(value)
 };
 Map<String, dynamic> publicToken = 
{
   "contentType": IDL.Text,
   "createdAt": IDL.Int,
   "id": IDL.Text,
   "owner": IDL.Principal,
   "payload": IDL.Variant(payloadResult),
   "properties": IDL.Vec(IDL.Record(property))
 };
final nftIdl = IDL.Service({
  NFTMethod.tokenByIndex: IDL.Func([IDL.Text], [IDL.Variant({"err": IDL.Variant(errParam),"ok": IDL.Record(publicToken)})], ['update']),
});

class NFTCanister extends ActorHook {
  NFTCanister();
  factory NFTCanister.create(CanisterActor _actor) {
    return NFTCanister()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<Uint8List> tokenByIndex(String idx) async {
    try {
      var res = await actor.getFunc(NFTMethod.tokenByIndex)!([idx]);
      if (res != null) {
        List<int> payload = res["ok"]["payload"]["Complete"].cast<int>();
        return Uint8List.fromList(payload);
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

}
