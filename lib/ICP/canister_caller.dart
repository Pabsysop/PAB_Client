import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/auth_client/webauth_provider.dart';
import 'package:flutter/services.dart'; 

import 'nais.dart';
import 'init.dart';

class CanisterCaller{
  int _count = 0;
  bool _loading = false;
  String _status = "";
  Identity? _identity;
  late Counter _counter;

  CanisterCaller();

  void initCounter() {
    _counter = AgentFactory.create(
      canisterId: "r7inp-6aaaa-aaaaa-aaabq-cai",
      url: "http://127.0.0.1:8000", // For Android emulator, please use 10.0.2.2 as endpoint
      idl: idl,
      identity: _identity,
    ).hook(Counter());
  }

  void loading(bool state) {
      _loading = state;
  }

  void readCount() async {
    int c = await _counter.count();
    loading(false);
    _count = c;
  }

  void increase() async {
    loading(true);
    await _counter.add();
    readCount();
  }

  void authenticate() async {
    try {
      var authClient = WebAuthProvider(
          scheme: "identity",
          path: 'auth',
          authUri: Uri.parse('http://localhost:8080/#authorize'),
          useLocalPage: false);

      await authClient.login(
          // AuthClientLoginOptions()..canisterId = "rwlgt-iiaaa-aaaaa-aaaaa-cai"
          );
      var loginResult = await authClient.isAuthenticated();
      _identity = authClient.getIdentity();
      _status = 'Got result: $loginResult';

    } on PlatformException catch (e) {
      _status = 'Got error: $e';
    }
  }
}
