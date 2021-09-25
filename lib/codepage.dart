import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/ICP/agent_factory.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:pem/pem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

final TextEditingController myController = TextEditingController();
PopupHUD showProgress(BuildContext context){
  final popup = PopupHUD(
    context,
    hud: HUD(
      label: '申请PAB元宇宙公民Visa NFT',
      detailLabel: 'applying..',
    ),
  );

  popup.show();

  return popup;
}

class CodePage extends StatelessWidget {
  CodePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "输入你的邀请码",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: bodyFontSize),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                maxLength: 64,
                controller: myController,
                style: TextStyle(letterSpacing: 2, fontSize: 15),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  counterText: "",
                  filled: true,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: new List<Widget>.generate(16, (index) {
                        return new GridTile(
                          child: new Card(
                            color: Colors.blue.shade200,
                            child: new Center(
                              child: new Text('$index'),
                            )
                          ),
                        );
                      }),
                    )
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonPrimary,
                  onPrimary: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(150, 50), //////// HERE
                ),
                onPressed: () async {
                  var popup = showProgress(context);
                  Uint8List seed = myController.text.substring(0, 64).toU8a();
                  var _identity = Ed25519KeyIdentity.generate(seed);
                  popup.setValue(0.2);
                  popup.setDetailLabel('Progress ${(0.2 * 100).toInt()}%..');
                  var _nais = NaisAgentFactory.create(
                                canisterId: naisCanisterId,
                                url: replicaUrl,
                                idl: naisIdl,
                                identity: _identity,
                          ).hook(Nais());
                  var lifeId = await _nais.applyCitizen(myController.text);

                  popup.setValue(0.6);
                  popup.setDetailLabel('Progress ${(0.6 * 100).toInt()}%..');
                  var pkStr = PemCodec(PemLabel.privateKey).encode(_identity.getKeyPair().secretKey);
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("lifeCanisterID", lifeId.toText());
                  prefs.setString("pKey", pkStr);
                  popup.setValue(1.0);
                  popup.setDetailLabel('Progress ${(1.0 * 100).toInt()}%..');

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (c) => Scaffold(body: LoginPage())),
                  );
                },
                child: Text(
                  '->',
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
