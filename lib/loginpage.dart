import 'dart:io';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:clubhouse_clone_ui_kit/ICP/nais.dart';
import 'package:clubhouse_clone_ui_kit/avatars_page.dart';
import 'package:clubhouse_clone_ui_kit/constant.dart';
import 'package:clubhouse_clone_ui_kit/draw_example.dart';
import 'package:clubhouse_clone_ui_kit/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ICP/agent_factory.dart';

class LoginPage extends StatefulWidget {
  final Principal lifeid;
  LoginPage(this.lifeid);

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
  late Principal _myLife;
  late String _myAvatar = "not nft avatar";
  
  @override
  void initState() {
    super.initState();
    _myLife = widget.lifeid;
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
                    url: "http://192.168.153.192:8000",
                    idl: naisIdl,
                    identity: _identity,
              ).hook(Nais());
      _nais.makeAvatarNFT(WasmType.VisaNFT, contents);
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
              Text(
                "#$_myLife #$_myAvatar",
                style: TextStyle(fontSize: headingFontSize),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
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
      )),
    );
  }
}
