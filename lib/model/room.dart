import 'package:agent_dart/agent_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:partyboard_client/model/user.dart';

    // pub tickets: Vec<Ticket>,
    // pub groups: Vec<Group>,
    // pub messages: Vec<Message>,

class Room  with ChangeNotifier {
  final String id;
  final String title;
  final String cover;
  final Principal owner;
  final Principal clubId;
  List<Principal> allows = [];
  List<Principal> moderators = [];
  List<Principal> speakers = [];
  List<Principal> audiens = [];
  List<User> allowsUsers = [];
  List<User> moderatorsUsers = [];
  List<User> speakersUsers = [];
  List<User> audiensUsers = [];
  num fee = 0.0;

  Room(this.id, this.title, this.cover, this.owner, this.clubId);

}
