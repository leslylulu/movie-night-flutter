import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import 'welcome_screen.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0;
  int _currentPage = 1;
  final String _apiKey = "679f6362eb5ed713e61291e91ae499cc";

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&page=$_currentPage"));
    final data = jsonDecode(response.body);
    setState(() {
      _movies.addAll(List<Map<String, dynamic>>.from(data['results']));
      _currentPage++;
      if (kDebugMode) {
        print("Movies: $_movies");
      }
    });
  }

  Future<void> _voteMovie(bool vote) async {
    final sessionId = Provider.of<AppState>(context, listen: false).sessionId;
    final movieId = _movies[_currentIndex]['id'];
    final response = await HttpHelper.voteMovie(sessionId, movieId, vote);
    final result = response['data'];

    if (result['match']) {
      _showMatchDialog(result['movie']);
    } else {
      _loadNextMovie();
    }
  }

  void _showMatchDialog(Map<String, dynamic> movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Match Found!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You matched on: ${movie['title']}'),
              Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _loadNextMovie() {
    setState(() {
      _currentIndex++;
      if (_currentIndex >= _movies.length) {
        _fetchMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = _movies[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie Choices',
          style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Dismissible(
        key: ValueKey(movie["id"]),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) => {
          _voteMovie(direction == DismissDirection.endToStart),
        },
        background: Container(
          color: Colors.yellow,
          alignment: Alignment.center,
          child: const Icon(Icons.thumb_down, size: 50),
        ),
        secondaryBackground: Container(
          color: Colors.yellow,
          alignment: Alignment.center,
          child: const Icon(Icons.thumb_up, size: 50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        width: 300,
                        height: 300,
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      movie['title'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${movie['release_date']}",
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(width: 32),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${movie['vote_average']}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
