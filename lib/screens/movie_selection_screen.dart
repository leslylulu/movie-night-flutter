import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final data = await HttpHelper.fetchMovies(_currentPage);
    if (!mounted) return;
    setState(() {
      _movies.addAll((data['results'] as List)
          .map((movie) => movie as Map<String, dynamic>)
          .toList());
      _currentPage++;
      if (kDebugMode) {
        final sessionId2 =
            Provider.of<AppState>(context, listen: false).sessionId;
        print("sessionId: $sessionId2");
      }
    });
  }

  Future<void> _voteMovie(bool vote) async {
    if (kDebugMode) {
      print("vote: $vote");
    }
    final sessionId = Provider.of<AppState>(context, listen: false).sessionId;
    final movieId = _movies[_currentIndex]['id'];
    final response = await HttpHelper.voteMovie(sessionId, movieId, vote);
    final result = response['data'];
    if (response.containsKey('code')) {
      _showErrorDialog(response['message']);
    } else {
      if (result['match']) {
        _showMatchDialog(result['movie_id']);
      } else {
        _loadNextMovie();
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMatchDialog(String movieId) {
    final movie = _movies.firstWhere(
      (movie) => movie['id'].toString() == movieId,
      orElse: () => <String, dynamic>{},
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${movie['title']} Winners 👑'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              movie['poster_path'] != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default_poster.jpg',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
              Text(' ${movie['title']} is matching the movie you voted!'),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
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
      if (kDebugMode) {
        print("movieId: ${_movies[_currentIndex]['id']}");
      }
      if (_currentIndex >= _movies.length) {
        _fetchMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (_movies.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = _movies[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Choices',
          style: textTheme.headlineMedium,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      body: Container(
        color: colorScheme.surface,
        child: Dismissible(
          key: ValueKey(movie["id"]),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) => {
            _voteMovie(direction == DismissDirection.endToStart),
          },
          background: Container(
            color: colorScheme.secondary,
            alignment: Alignment.center,
            child: const Icon(Icons.thumb_down, size: 50),
          ),
          secondaryBackground: Container(
            color: colorScheme.secondary,
            alignment: Alignment.center,
            child: const Icon(Icons.thumb_up, size: 50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                color: colorScheme.secondary,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: colorScheme.onSecondary,
                                size: 24,
                              ),
                              Icon(
                                Icons.thumb_down,
                                color: colorScheme.onSecondary,
                                size: 20,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.thumb_up,
                                color: colorScheme.onSecondary,
                                size: 20,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: colorScheme.onSecondary,
                                size: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: movie['poster_path'] != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/default_poster.jpg',
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie['title'],
                        style: textTheme.displaySmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${movie['release_date']}",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${movie['original_language']}",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Vote Count: ${movie['vote_count']}",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${movie['vote_average']}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
