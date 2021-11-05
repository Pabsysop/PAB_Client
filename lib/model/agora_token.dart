import 'dart:convert';
import 'package:http/http.dart' as http;

class AgoraRTMToken {
  final String rtmToken;

  AgoraRTMToken({
    required this.rtmToken,
  });

  factory AgoraRTMToken.fromJson(Map<String, dynamic> json) {
    return AgoraRTMToken(
      rtmToken: json['rtmToken'],
    );
  }

  static Future<AgoraRTMToken> fetchAlbum(String uid) async {
    final response = await http
    .get(Uri.parse('http://partyboard.org:8080/rtm/'+uid));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AgoraRTMToken.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}