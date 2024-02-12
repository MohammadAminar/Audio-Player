// ignore_for_file: must_be_immutable

import 'package:audio_player/controllers/page_manager.dart';
import 'package:audio_player/screens/home-screen.dart';
import 'package:audio_player/screens/music_player_screen.dart';
import 'package:audio_player/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() async {
  await setupInitService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  PageController controller = PageController(
    initialPage: 0,
  );

  PageManager get pageManager => PageManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.redAccent,
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: [
              HomeScreen(controller, pageManager),
              WillPopScope(
                onWillPop: () async {
                  controller.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                  return false;
                },
                child: MusicPlayerScreen(controller, pageManager),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
