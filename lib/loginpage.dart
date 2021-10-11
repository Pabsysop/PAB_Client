import 'dart:io';
import 'dart:typed_data';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:partyboard_client/ICP/anderson.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/avatars_page.dart';
import 'package:partyboard_client/constant.dart';
import 'package:partyboard_client/draw_example.dart';
import 'package:partyboard_client/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partyboard_client/utils.dart';
import 'package:pem/pem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ICP/agent_factory.dart';
import 'package:flutter/services.dart' show rootBundle;


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double size = 220;
  Identity? _identity;
  Principal? _myLife;
  bool enableNext = false;
  Uint8List _avatarBytes = Uint8List(0);
  String _defaultAvatar = "assets/images/avatar-1.jpg";
  String _avatarDesc = "not NFT Avatar";
  
  @override
  void initState(){
    super.initState();
    getUserEnv();
    setImageBytes();
  }

  void getUserEnv() {
    SharedPreferences.getInstance().then((prefs) {
      String? lifeId = prefs.getString(lifePrefsKey);
      if (lifeId != null) {
        setState(() {
          _myLife = Principal.fromText(lifeId);
        });
      }
      String? pKey = prefs.getString(pkeyPrefsKey);
      if (pKey != null) {
        var pkBytes = PemCodec(PemLabel.privateKey).decode(pKey);
        setState(() {
          _identity = Ed25519KeyIdentity.fromSecretKey(Uint8List.fromList(pkBytes));
        });
      }
      if (_myLife != null && _identity != null){
        setState(() {
          enableNext = true;
        });
      }
    });
  }

  void setImageBytes(){
    rootBundle.load(_defaultAvatar).then(
      (contents){
        setState(() {
          _avatarBytes = contents.buffer.asUint8List();
        });
    });
  }

  void nextPressed(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  Future<void> upAvatar(String id, String src) {
    var anderson = NaisAgentFactory.create(
          canisterId: _myLife!.toText(),
          url: replicaUrl,
          idl: andersonIdl,
          identity: _identity,
    ).hook(Anderson());
    return anderson.upAvatar(id, src);
  }

  Future<void> requestAvatarNFT(Uint8List contents, BuildContext context) async{
      var nais = NaisAgentFactory.create(
            canisterId: naisCanisterId,
            url: replicaUrl,
            idl: naisIdl,
            identity: _identity,
      ).hook(Nais());

      var pop = showProgress(context, "upload nft data");
      var avatarIdx = await nais.makeAvatarNFT(contents);
      await upAvatar(avatarIdx, "DFINITY");
      setState(() {
        _avatarDesc = "NFT Avatar #" + avatarIdx;
      });
      pop.dismiss();
  }

  void _openFileExplorer(BuildContext context) async {
    try {
      var paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: null,
      ))?.files;
      var fd = File(paths!.single.path!);
      var contents = await fd.readAsBytes();

      await requestAvatarNFT(contents, context);

      setState(() {
        _avatarBytes = contents;
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
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
                    child: Image.memory(_avatarBytes,
                      width: size,
                      height: size,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(_avatarDesc),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async{
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AvatarsPage()),
                          );
                          if (result != null){
                            setState(() {
                              _defaultAvatar = result;
                            });
                            setImageBytes();
                            await upAvatar(_defaultAvatar, "LOCAL");
                          }
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final bytes = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyDrawPage()),
                          );
                          if (bytes != null){
                            setState(() {
                              _avatarBytes = bytes;
                            });
                            await requestAvatarNFT(bytes, context);
                          }
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.upload),
                        onPressed: (){
                          _openFileExplorer(context);
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
                onPressed: enableNext ? () => nextPressed(context) : null,
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
