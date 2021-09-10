import 'package:agent_dart/agent_dart.dart';
import 'package:clubhouse_clone_ui_kit/ICP/agent_factory.dart';
import 'package:clubhouse_clone_ui_kit/ICP/nais.dart';
import 'package:clubhouse_clone_ui_kit/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';
import 'package:progress_hud/progress_hud.dart';

final TextEditingController myController = TextEditingController();
var progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
);

class CodePage extends StatelessWidget {
  const CodePage({Key? key}) : super(key: key);
  
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
                  var seed = myController.text.substring(0, 64).toU8a();
                  var _identity = Ed25519KeyIdentity.generate(seed);
                  var _nais = NaisAgentFactory.create(
                                canisterId: naisCanisterId,
                                url: replicaUrl,
                                idl: naisIdl,
                                identity: _identity,
                          ).hook(Nais());
                  var lifeId = await _nais.applyCitizen(myController.text);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (c) => Scaffold(body: LoginPage(lifeId))),
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
