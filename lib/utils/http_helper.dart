import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpHelper {
  static String movieNightBaseUrl = "https://movie-night-api.onrender.com";

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse("$movieNightBaseUrl/start-session?device_id=$deviceId"));
    return jsonDecode(response.body);
  }

  static joinSession(String code, String deviceId) async {
    var response = await http.get(Uri.parse(
        "$movieNightBaseUrl/join-session?code=$code&device_id=$deviceId"));
    return jsonDecode(response.body);
  }

  static voteMovie(String sessionId, int movieId, bool vote) async {
    var response = await http.get(Uri.parse(
        "$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote"));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> fetchMovies(int page) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$page"));
    return jsonDecode(response.body);
  }
}
