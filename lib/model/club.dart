import 'package:agent_dart/agent_dart.dart';
import 'package:partyboard_client/ICP/agent_factory.dart';
import 'package:partyboard_client/ICP/board.dart';
import 'package:partyboard_client/ICP/nais.dart';
import 'package:partyboard_client/model/user.dart';

class Club {
  Principal boardId;
  List<User> followers = [];
  Board? _boardClient;
  String? title;
  String? about;
  String? cover;

  Club(this.boardId);

  static Club newClub(Principal boardId) {
    return Club(boardId);
  }

  Future<List> myMeta(Identity? ident) async {
    if (_boardClient == null){
      _boardClient = NaisAgentFactory.create(
            canisterId: boardId.toText(),
            url: replicaUrl,
            idl: boardIdl,
            identity: ident,
      ).hook(Board());
    }
    var res = await _boardClient!.hi();
    List<String> boardMeta = res[0];
    this.title = boardMeta[0];
    this.cover = boardMeta[1];
    this.about = boardMeta[2];

    return res[1];
  }

  setFollowers(List<User> followers) {
    this.followers = followers;
  }

  addFollowers(User user) {
    followers.add(user);
  }

  removeFollowers(User user) {
    followers.remove(user);
  }
}
