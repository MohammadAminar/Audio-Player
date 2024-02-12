import 'package:audio_player/controllers/page_manager.dart';
import 'package:audio_player/services/audio_handler.dart';
import 'package:audio_player/services/playlist_repository.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future setupInitService() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlayListRepository>(() => MyPlayList());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
