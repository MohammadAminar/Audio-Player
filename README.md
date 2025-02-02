# Audio Player Flutter App

A simple and elegant music player app built with Flutter and Dart. This application allows you to play music, manage playlists, view song details, and control playback.

## Features

- Play music from URLs
- Manage playlists
- Display song details (title, artist, artwork)
- Playback controls (play, pause, previous, next)
- Progress bar for playback
- Repeat functionality (repeat one, repeat all)
- Volume control
- Beautiful and responsive UI

## Prerequisites

To run this project, you need to install the following tools:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- A code editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

## Installation and Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/username/repository-name.git

2. **Navigate to the project directory**:
```
cd repository-name
```

3. **Install dependencies**:
```
flutter pub get
```

4. **Run the project**:
```
flutter run
```

## Project Structure
```
├── android
├── assets
│   ├── fonts
│   └── images
├── ios
├── lib
│   ├── controllers
│   ├── main.dart
│   ├── screens
│   └── services
├── linux
├── macos
├── test
├── web
└── windows
```

## Dependencies
This project uses the following packages:
- just_audio: For audio playback.

- audio_service: For background audio management.

- audio_video_progress_bar: For displaying playback progress.

- get_it: For dependency injection.

For a complete list of dependencies, check the `pubspec.yaml` file.

## Contributing
If you'd like to contribute to this project, follow these steps:
1. Fork the repository.
2. Create a new branch:
```
git checkout -b feature/your-feature-name
```
3. Commit your changes:
```
git commit -m "Add some feature"
```
4. Push your changes to your fork:
Push your changes to your fork:
```
git push origin feature/your-feature-name
```
5. Create a Pull Request.

## License
This project is licensed under the MIT License.
