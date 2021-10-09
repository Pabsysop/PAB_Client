import 'package:agent_dart/agent_dart.dart';
import 'agent_factory.dart';


class NFTMethod {
  static const tokenByIndex = "tokenByIndex";
}

Map<String, CType<dynamic>> ErrParam = 
 {
   "AuthorizedPrincipalLimitReached": IDL.Nat,
   "Immutable": IDL.Null,
   "InvalidRequest": IDL.Null,
   "NotFound": IDL.Null,
   "Unauthorized": IDL.Null,
 };
 Map<String, dynamic>  Chunk = 
 {
   "data": IDL.Vec(IDL.Nat8),
   "nextPage": IDL.Opt(IDL.Nat),
   "totalPages": IDL.Nat
 };
 Map<String, CType<dynamic>> PayloadResult = 
 {
   "Chunk": IDL.Record(Chunk),
   "Complete": IDL.Vec(IDL.Nat8)
 };
 Map<String, CType<dynamic>>  Value = 
{
   "Bool": IDL.Bool,
   "Class": IDL.Vec(IDL.Record(Property)),
   "Empty": IDL.Empty,
   "Float": IDL.Float64,
   "Int": IDL.Int32,
   "Nat": IDL.Nat,
   "Principal": IDL.Principal,
   "Text": IDL.Text
 };
 Map<String, dynamic> Property =
{
   "immutable": IDL.Bool,
   "name": IDL.Text,
   "value": IDL.Variant(Value)
 };
 Map<String, dynamic> PublicToken = 
{
   "contentType": IDL.Text,
   "createdAt": IDL.Nat,
   "id": IDL.Text,
   "owner": IDL.Principal,
   "payload": IDL.Variant(PayloadResult),
   "properties": IDL.Vec(IDL.Record(Property))
 };
final nftIdl = IDL.Service({
  NFTMethod.tokenByIndex: IDL.Func([IDL.Text], [IDL.Variant({"err": IDL.Variant(ErrParam),"ok": IDL.Record(PublicToken)})], ['query']),
});

class NFTCanister extends ActorHook {
  NFTCanister();
  factory NFTCanister.create(CanisterActor _actor) {
    return NFTCanister()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<Map<String, Map<String, dynamic>>> tokenByIndex(String idx) async {
    try {
      var res = await actor.getFunc(NFTMethod.tokenByIndex)!([idx]);
      if (res != null) {
        return res[0] as Map<String, Map<String, dynamic>>;
      }
      throw "apply failed due to $res";
    } catch (e) {
      rethrow;
    }
  }

}
