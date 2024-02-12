// ignore_for_file: unnecessary_null_comparison

import 'package:audio_player/services/playlist_repository.dart';
import 'package:audio_player/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final _audioHandler = getIt<AudioHandler>();
  final _audioPlayer = getIt<AudioHandler>();
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier(ButtonState.paused);
  final currentSongDetailNotifier = ValueNotifier<MediaItem>(
    const MediaItem(
      id: '-1',
      title: '',
    ),
  );
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = RepeatStateNotifier();
  final volumeStateNotifier = ValueNotifier<double>(1);

  late ConcatenatingAudioSource _playlist;

  PageManager(AudioPlayer audioPlayer) {
    _init();
  }

  void _init() async {
    _loadPlayList();
    _listenChangeInPlayList();
    _listenToPlaybackState();
    _listenToCurrentSong();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _setInitialPlayList();
    _listenChangePlayerState();
    _listenChangePositionStream();
    _listenChangeBufferedPositionStream();
    _listenChangeTotalDurationStream();
    _listenChangInSequenceState();
  }

  Future _loadPlayList() async {
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.fetchMyPlayList();
    final mediaItems = playList
        .map(
          (song) => MediaItem(
            id: song['id'] ?? '-1',
            title: song['title'] ?? '',
            artist: song['artist'],
            artUri: Uri.parse(song['artUri'] ?? ''),
            extras: {'url': song['url']},
          ),
        )
        .toList();

    _audioHandler.addQueueItems(mediaItems);
  }

  _listenChangeInPlayList() {
    _audioHandler.queue.listen(
      (playlist) {
        if (playlist.isEmpty) {
          return;
        } //
        final newList = playlist.map((item) => item).toList();
        playlistNotifier.value = newList;
      },
    );
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen(
      (playbackState) {
        final isPlaying = playbackState.playing;
        final processingState = playbackState.processingState;
        if (processingState == AudioProcessingState.loading ||
            processingState == AudioProcessingState.buffering) {
          buttonNotifier.value = ButtonState.loading;
        } //
        else if (!isPlaying) {
          buttonNotifier.value = ButtonState.paused;
        } //
        else if (processingState != AudioProcessingState.completed) {
          buttonNotifier.value = ButtonState.playing;
        } //
        else {
          _audioHandler.seek(Duration.zero);
          _audioHandler.pause();
        }
      },
    );
  }

  _listenToCurrentSong() {
    final playlist = _audioHandler.queue.value;
    _audioHandler.mediaItem.listen(
      (mediaItem) {
        currentSongDetailNotifier.value =
            mediaItem ?? const MediaItem(id: '-1', title: '');
        if (playlist.isEmpty || mediaItem == null) {
          isFirstSongNotifier.value = true;
          isLastSongNotifier.value = true;
        } //
        else {
          isFirstSongNotifier.value = playlist.first == mediaItem;
          isLastSongNotifier.value = playlist.last == mediaItem;
        }
      },
    );
  }

  _listenToCurrentPosition() {
    AudioService.position.listen(
      (position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      },
    );
  }

  _listenToBufferedPosition() {
    _audioHandler.playbackState.listen(
      (playBackState) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playBackState.bufferedPosition,
          total: oldState.total,
        );
      },
    );
  }

  _listenToTotalDuration() {
    _audioHandler.mediaItem.listen(
      (mediaItem) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem!.duration ?? Duration.zero,
        );
      },
    );
  }

  void _setInitialPlayList() async {
    const prefix = 'assets/images';

    final song1 = Uri.parse(
        'https://dl.rozmusic.com/Music/1402/07/05/Asef%20Aria%20-%20Dastat.mp3');
    final song2 = Uri.parse(
        'https://dl.rozmusic.com/Music/1402/07/05/Reza%20Bahram%20-%20Mane%20Divaneh.mp3');
    final song3 = Uri.parse(
        'https://dl.rozmusic.com/Music/1402/06/11/Erfan%20Tahmasbi%20-%20To.mp3');
    final song4 = Uri.parse(
        'https://dl.rozmusic.com/Music/1402/06/30/Pooriya%20Ariyan%20-%20Labkhand.mp3');
    final song5 = Uri.parse(
        'https://dls.music-fa.com/tagdl/99/Behnam%20Bani%20-%20KhoshHalam%20(320).mp3');

    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
            title: 'Dastat',
            artist: 'Asef Aria',
            imageAddress: '$prefix/Asef-Aria-Dastat.jpg',
          ),
        ),
        AudioSource.uri(
          song2,
          tag: AudioMetaData(
            title: 'Mane divaneh',
            artist: 'Reza bahram',
            imageAddress: '$prefix/Reza-Bahram-Mane-Divaneh.jpg',
          ),
        ),
        AudioSource.uri(
          song3,
          tag: AudioMetaData(
            title: 'Del az man delbari az to',
            artist: 'Erfan tahmasbi',
            imageAddress: '$prefix/Erfan-Tahmasbi-Del.jpg',
          ),
        ),
        AudioSource.uri(
          song4,
          tag: AudioMetaData(
            title: 'Labkhand',
            artist: 'Pooriya ariyan',
            imageAddress: '$prefix/Pooriya-Ariyan-Labkhand.jpg',
          ),
        ),
        AudioSource.uri(
          song5,
          tag: AudioMetaData(
            title: 'Khoshhalam',
            artist: 'Behnam bani',
            imageAddress: '$prefix/bani.jpg',
          ),
        ),
      ],
    );

    if (_audioPlayer.bufferedPosition == Duration.zero) {
      _audioPlayer.setAudioSource(_playlist);
    }
  }

  void _listenChangePlayerState() {
    _audioPlayer.playerStateStream.listen(
      (playerState) {
        final playing = playerState.playing;
        final proccessingState = playerState.processingState;
        if (proccessingState == ProcessingState.loading ||
            proccessingState == ProcessingState.buffering) {
          buttonNotifier.value = ButtonState.loading;
        } //
        else if (!playing) {
          buttonNotifier.value = ButtonState.paused;
        } //
        else if (proccessingState == ProcessingState.completed) {
          _audioPlayer.stop();
          buttonNotifier.value = ButtonState.paused;
        } //
        else {
          buttonNotifier.value = ButtonState.playing;
        }
      },
    );
  }

  void _listenChangePositionStream() {
    _audioPlayer.positionStream.listen(
      (position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      },
    );
  }

  void _listenChangeBufferedPositionStream() {
    _audioPlayer.bufferedPositionStream.listen(
      (position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: position,
          total: oldState.total,
        );
      },
    );
  }

  void _listenChangeTotalDurationStream() {
    _audioPlayer.durationStream.listen(
      (position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: position ?? Duration.zero,
        );
      },
    );
  }

  void _listenChangInSequenceState() {
    _audioPlayer.sequenceStateStream.listen(
      (sequenceState) {
        if (sequenceState == null) {
          return;
        }

        // update current song detail
        final currentItem = sequenceState.currentSource;
        final song = currentItem!.tag as AudioMetaData;
        currentSongDetailNotifier.value = song as MediaItem;

        //update playlist
        final playList = sequenceState.effectiveSequence;
        final title = playList.map(
          (song) {
            return song.tag as AudioMetaData;
          },
        ).toList();
        playlistNotifier.value = title;

        // update previous and next button
        if (playList.isEmpty || currentItem == null) {
          isFirstSongNotifier.value = true;
          isLastSongNotifier.value = true;
        } //
        else {
          isFirstSongNotifier.value = playList.first == currentItem;
          isLastSongNotifier.value = playList.last == currentItem;
        }

        // update volume button
        if (_audioPlayer.volume != 0) {
          volumeStateNotifier.value = 1;
        } //
        else {
          volumeStateNotifier.value = 0;
        }
      },
    );
  }

  void onVolumePressed() {
    if (volumeStateNotifier.value != 0) {
      _audioHandler.androidSetRemoteVolume(0);
      volumeStateNotifier.value = 0;
    } //
    else {
      _audioHandler.androidSetRemoteVolume(1);
      volumeStateNotifier.value = 1;
    }
  }

  void play() async {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void seek(position) {
    _audioHandler.seek(position);
  }

  void playFromPlaylist(int index) {
    _audioHandler.skipToQueueItem(index);
  }

  void onPreviousPressed() {
    _audioHandler.skipToPrevious();
  }

  void onNextPressed() {
    _audioHandler.skipToNext();
  }

  void onRepeatPressed() {
    repeatStateNotifier.nextState();
    switch (repeatStateNotifier.value) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }
}

class AudioMetaData {
  final String title;
  final String artist;
  final String imageAddress;

  AudioMetaData({
    required this.title,
    required this.artist,
    required this.imageAddress,
  });
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }

enum RepeatState { one, all, off }

class RepeatStateNotifier extends ValueNotifier<RepeatState> {
  RepeatStateNotifier() : super(_initialValue);
  static const _initialValue = RepeatState.off;

  void nextState() {
    var next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}
