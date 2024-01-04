import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final playingVideo = StateProvider<bool>((ref) => false);

final videoProvider =
    FutureProvider.autoDispose<VideoPlayerController?>((ref) async {
  VideoPlayerController? player;
  ref.onDispose(() {
    print('disposed====================================================');
    player!.dispose();
  });

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.video,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    player = VideoPlayerController.file(file);
    player.initialize();
    ref.read(playingVideo.notifier).state = true;
    //ref.read(videoPlayerProvider.notifier).state = videoPlayerController;
    return player;
  } else {
    return null;
  }
});
