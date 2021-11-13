import 'dart:convert';
import 'package:http/http.dart' as http;

class AgoraToken {
  final String rtcToken;

  AgoraToken({
    required this.rtcToken,
  });

  factory AgoraToken.fromJson(Map<String, dynamic> json) {
    return AgoraToken(
      rtcToken: json['rtcToken'],
    );
  }

  static Future<AgoraToken> fetchRTMToken(String uid) async {
    final response = await http
    .get(Uri.parse('http://partyboard.org:8080/rtm/'+uid));

    if (response.statusCode == 200) {
      return AgoraToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get token');
    }
  }

  // rtc/:channelName/:role/:tokentype/:uid/
  static Future<AgoraToken> fetchRTCToken(String uid, String channel, String role) async {
    final response = await http
    .get(Uri.parse('http://partyboard.org:8080/rtc/'+channel+'/'+role+'/userAccount/'+uid));

    if (response.statusCode == 200) {
      return AgoraToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get token');
    }
  }

}
