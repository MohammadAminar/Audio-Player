// ignore_for_file: file_names

import 'package:audio_player/controllers/page_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
    this.pageController,
    this._pageManager, {
    super.key,
  });

  final PageController pageController;
  final PageManager _pageManager;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey,
            child: const Center(
              child: Text(
                'Play List',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _pageManager.playlistNotifier,
              builder: (context, List<MediaItem> song, child) {
                if (song.isEmpty) {
                  return Container();
                } //
                else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: song.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        child: ListTile(
                          tileColor: Colors.grey.shade200,
                          title: Text(song[index].title),
                          subtitle: Text(song[index].artist ?? ''),
                          onTap: () {
                            pageController.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: 300,
                              ),
                              curve: Curves.easeOut,
                            );
                            // _pageManager.playFromPlaylist(index);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, MediaItem audio, _) {
              if (audio.id == '-1') {
                return Container();
              } //
              else {
                return Container(
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 45,
                      backgroundImage: NetworkImage(audio.artUri.toString()),
                    ),
                    title: Text(audio.title),
                    subtitle: Text(audio.artist ?? ''),
                    trailing: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _pageManager.buttonNotifier,
                        builder: (context, ButtonState value, child) {
                          switch (value) {
                            case ButtonState.loading:
                              return const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                ),
                              );
                            case ButtonState.playing:
                              return SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.pause,
                                  icon: const Icon(
                                    Icons.pause_circle_outline_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                              );
                            case ButtonState.paused:
                              return SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.play,
                                  icon: const Icon(
                                    Icons.play_circle_outline_rounded,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
