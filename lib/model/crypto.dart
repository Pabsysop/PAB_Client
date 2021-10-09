import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:pem/pem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

List<int> num = Iterable.generate(10, (x) => x).toList();

class Crypto {
  static List<int> genRandomPasscode() {

    int chara = 'a'.codeUnitAt(0);
    List<int> lower = Iterable.generate(26, (x) => chara + x).toList();

    int charA = 'A'.codeUnitAt(0);
    List<int> higher = Iterable.generate(26, (x) => charA + x).toList();

    lower.addAll(higher);
    lower.addAll(num);

    return lower;
  }

  static Future<Identity> getIdentity() async{
    Identity? ident;
    var prefs = await SharedPreferences.getInstance();
      String? pKey = prefs.getString(pkeyPrefsKey);
      if (pKey != null) {
        var pkBytes = PemCodec(PemLabel.privateKey).decode(pKey);
        ident = Ed25519KeyIdentity.fromSecretKey(Uint8List.fromList(pkBytes));
      }
      return ident ?? Ed25519KeyIdentity.generate("invalidKey".toU8a());
  }

}
