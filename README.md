# Movie Night

Movie Night is a Flutter application that helps friends decide on movies to watch together. Users can create or join sessions, vote on movies, and find common interests in films.

### 🎬 Watch the video: Movie Night

[![Watch the video](https://i.vimeocdn.com/video/1764763822-b5a2fc4e0a748016f8c9b27473b6fd62570f5c6a5f3b2d12e06fba0e1019b0fa-d_640x360.jpg)](https://vimeo.com/1063321923)


## Features

- **Session Management**: Create or join movie selection sessions using unique codes
- **Movie Discovery**: Browse through popular movies from TMDB API
- **Voting System**: Vote for movies you're interested in watching
- **Match Finding**: Find movies that multiple users have voted on
- **Cross-Platform**: Works on iOS, Android, and web

## Getting Started

### Prerequisites

- Flutter SDK (v3.5.4 or later)
- Dart SDK (v3.5.4 or later)
- TMDB API key

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/movie_night.git
cd movie_night
```

2. Create a `.env` file in the root directory with your TMDB API key:
```
TMDB_API_KEY=your_tmdb_api_key_here
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Project Structure

- `lib/`: Main source code
  - `screens/`: UI screens
  - `utils/`: Utility classes and functions
  - `widgets/`: Reusable widgets
- `assets/`: Images and fonts
  - `images/`: App icons and images
  - `fonts/`: Custom fonts (Poppins)

## Dependencies

- `flutter_dotenv`: For managing environment variables
- `http`: For making API requests
- `provider`: For state management
- `shared_preferences` and `path_provider`: For local storage
- `device_info_plus` and `android_id`: For device identification
- `flutter_launcher_icons` and `flutter_native_splash`: For app visuals

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [TMDB API](https://www.themoviedb.org/documentation/api) for providing movie data
- [Flutter team](https://flutter.dev/) for their amazing framework
