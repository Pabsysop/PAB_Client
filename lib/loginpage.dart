import 'dart:io';
import 'package:clubhouse_clone_ui_kit/codepage.dart';
import 'package:clubhouse_clone_ui_kit/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double size = 256;
  String? _fileName = "/home/defalut.txt";
  List<PlatformFile>? _paths;
  String? _directoryPath = "/home";
  String? _extension;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

void _openFileExplorer() async {
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))?.files;
      _directoryPath = _paths?.single.path;
      var fd = File(_directoryPath!);
      var contents = await fd.readAsBytes();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
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
                "# 好看的皮囊 #",
                style: TextStyle(fontSize: headingFontSize),
              ),
              Text(
                _fileName!,
                style: TextStyle(fontSize: headingFontSize),
              ),
              Text(
                _directoryPath!,
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
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
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
                    "可以使系统默认头像，可以生成PAB元宇宙头像NFT，也可以导入外部的头像NFT，NFT头像用户更拉风哦！",
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
                    MaterialPageRoute(builder: (context) => CodePage()),
                  );
                },
                child: Text(
                  '下一步 ->',
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
