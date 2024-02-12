// ignore_for_file: must_be_immutable, unreachable_switch_case

import 'dart:ui';
import 'package:audio_player/controllers/page_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen(this.controller, this.pageManager, {super.key});

  final PageController controller;
  final PageManager pageManager;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: ValueListenableBuilder(
            valueListenable: pageManager.currentSongDetailNotifier,
            builder: (context, MediaItem value, child) {
              if (value.id == '-1') {
                return Image.asset(
                  'assets/images/default.jpg',
                  fit: BoxFit.cover,
                );
              } //
              else {
                String image = value.artUri.toString();
                return FadeInImage(
                  placeholder: const AssetImage('assets/images/default.jpg'),
                  image: NetworkImage(
                    image,
                  ),
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: Colors.black45.withOpacity(0.6),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Now Playing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ValueListenableBuilder(
                      valueListenable: pageManager.currentSongDetailNotifier,
                      builder: (context, MediaItem value, child) {
                        if (value.id == '-1') {
                          return const CircleAvatar(
                            radius: 150,
                            backgroundImage: AssetImage(
                              'assets/images/default.jpg',
                            ),
                          );
                        } //
                        else {
                          String image = value.artUri.toString();
                          return CircleAvatar(
                            radius: 150,
                            backgroundImage: const AssetImage(
                              'assets/images/default.jpg',
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: FadeInImage(
                                height: 300,
                                placeholder: const AssetImage(
                                  'assets/images/default.jpg',
                                ),
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                              pageManager.currentSongDetailNotifier,
                          builder: (context, MediaItem value, child) {
                            String title = value.title;
                            String artist = value.artist ?? '';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.favorite,
                          color: Colors.grey,
                          size: 35,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder<ProgressBarState>(
                      valueListenable: pageManager.progressNotifier,
                      builder: (context, value, _) {
                        return ProgressBar(
                          progress: value.current,
                          total: value.total,
                          buffered: value.buffered,
                          progressBarColor: Colors.redAccent,
                          thumbGlowColor: Colors.redAccent.withOpacity(0.25),
                          baseBarColor: Colors.grey,
                          thumbColor: Colors.white,
                          timeLabelTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          onSeek: pageManager.seek,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: pageManager.repeatStateNotifier,
                          builder: (context, RepeatState value, child) {
                            switch (value) {
                              case RepeatState.off:
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.repeat_rounded,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  onPressed: pageManager.onRepeatPressed,
                                );
                              case RepeatState.one:
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.repeat_one_rounded,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  onPressed: pageManager.onRepeatPressed,
                                );
                              case RepeatState.all:
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.repeat_on_rounded,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  onPressed: pageManager.onRepeatPressed,
                                );
                            }
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: pageManager.isFirstSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 35,
                              ),
                              color: Colors.white,
                              onPressed:
                                  value ? null : pageManager.onPreviousPressed,
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              colors: [
                                Colors.redAccent.withOpacity(0.8),
                                const Color(0xCC722530),
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                          ),
                          child: ValueListenableBuilder<ButtonState>(
                            valueListenable: pageManager.buttonNotifier,
                            builder: (context, ButtonState value, _) {
                              switch (value) {
                                case ButtonState.loading:
                                  return const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  );
                                case ButtonState.playing:
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: pageManager.pause,
                                    icon: const Icon(
                                      Icons.pause,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  );
                                case ButtonState.paused:
                                  return Center(
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: pageManager.play,
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: pageManager.isLastSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 35,
                              ),
                              color: Colors.white,
                              onPressed:
                                  value ? null : pageManager.onNextPressed,
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: pageManager.volumeStateNotifier,
                          builder: (context, double value, child) {
                            if (value == 0) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.volume_off_rounded,
                                  size: 35,
                                ),
                                color: Colors.white,
                                onPressed: pageManager.onVolumePressed,
                              );
                            } //
                            else {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                  size: 35,
                                ),
                                color: Colors.white,
                                onPressed: pageManager.onVolumePressed,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
