import 'package:audio_player/controllers/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this._audioPlayer, {
    Key? key,
  }) : super(key: key);
  final AudioPlayer _audioPlayer;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageManager _pageManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageManager = PageManager(widget._audioPlayer);
  }

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
                'PlayList',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _pageManager.playlistNotifier,
              builder: (context, List<AudioMetaData> song, child) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: song.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        tileColor: Colors.grey.shade200,
                        title: Text(song[index].title),
                        subtitle: Text(song[index].artist),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, AudioMetaData audio, _) {
              return Container(
                color: Colors.grey.shade300,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(audio.imageAddress),
                  ),
                  title: Text(audio.title),
                  subtitle: Text(audio.artist),
                  trailing: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
