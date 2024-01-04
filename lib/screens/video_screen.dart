import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
//import 'package:video_player_app/functions/player_controls.dart';
import 'package:video_player_app/functions/video_picker.dart';

class VideoPlayingScreen extends ConsumerWidget {
  const VideoPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final video = ref.watch(videoProvider);
    final isPlaying = ref.watch(playingVideo);
    final width = MediaQuery.of(context).size.width - 25.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Video Player'),
      ),
      body: SafeArea(
        child: video.when(
            data: (data) {
              double aspect;

              data != null ? aspect = data.value.aspectRatio : aspect = 1.0;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data != null
                          ? Expanded(
                              child: SizedBox(
                                  // height: width / aspect,
                                  // width: width,
                                  child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  VideoPlayer(data),
                                  // const ControlsOverlay(),
                                  //VideoProgressIndicator(data,
                                  //  allowScrubbing: true),
                                ],
                              )),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(playingVideo.notifier).state =
                              data!.value.isPlaying;
                          data.value.isPlaying ? data.pause() : data.play();
                          // ref.invalidate(videoProvider);
                          // ref.read(videoProvider);
                        },
                        child: Text(isPlaying ? 'Play' : 'Pause'),
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error, stack) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}
