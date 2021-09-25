import 'dart:io';
import 'dart:typed_data';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/avatars_page.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/draw_example.dart';
import 'package:partyboard_client/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pem/pem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ICP/agent_factory.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double size = 256;
  List<PlatformFile>? _paths;
  String? _extension;
  bool _multiPick = false;
  FileType _pickingType = FileType.image;
  late Nais _nais;
  Identity? _identity;
  Principal? _myLife;
  String _myAvatar = "not nft avatar";
  bool enableNext = false;
  
  void getUserEnv() {
    SharedPreferences.getInstance().then((prefs) {
      String? lifeId = prefs.getString("lifeCanisterID");
      if (lifeId != null) {
        setState(() {
          _myLife = Principal.fromText(lifeId);
        });
      }
      String? pKey = prefs.getString("pKey");
      if (pKey != null) {
        var pkBytes = PemCodec(PemLabel.privateKey).decode(pKey);
        setState(() {
          _identity = Ed25519KeyIdentity.fromSecretKey(Uint8List.fromList(pkBytes));
        });
      }
      enableNext = true;
      return;
    });
  }

  void nextPressed(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  void initState(){
    super.initState();
    getUserEnv();
  }

void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '').split(',') : null,
      ))?.files;
      var fd = File(_paths!.single.path!);
      var contents = await fd.readAsBytes();
      _nais = NaisAgentFactory.create(
            canisterId: naisCanisterId,
            url: replicaUrl,
            idl: naisIdl,
            identity: _identity,
      ).hook(Nais());
      var avatarId = await _nais.makeAvatarNFT(contents);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("avatar_nft", avatarId);
      setState(() {
        _myAvatar = avatarId;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "#$_myAvatar",
                    style: TextStyle(fontSize: headingFontSize),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () { }
                  ),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
                    child: Image.asset(
                      "assets/images/avatar-3.jpg",
                      width: size,
                      height: size,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AvatarsPage()),
                          );
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyDraw()),
                          );
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.upload),
                        onPressed: (){
                          _openFileExplorer();
                        }
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    avatarDecription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0),
                  )
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
                onPressed: !enableNext ? null : () => nextPressed(context),
                child: Text(
                  '->',
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
