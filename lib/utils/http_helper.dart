import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = "https://movie-night-api.onrender.com";

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse("$movieNightBaseUrl/start-session?device_id=$deviceId"));
    return jsonDecode(response.body);
  }

  static joinSession(String code, String deviceId) async {
    var response = await http.get(Uri.parse(
        "$movieNightBaseUrl/join-session?code=$code&device_Id=$deviceId"));
    return jsonDecode(response.body);
  }

  static voteMovie(String sessionId, int movieId, bool vote) async {
    var response = await http.get(Uri.parse(
        "$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote"));
    return jsonDecode(response.body);
  }
}
