import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:load_url_image/provider/video_provider.dart';
import 'package:load_url_image/utils/utils.dart';
import 'package:load_url_image/widgets/buffer_slider_controller_widget.dart';
import 'package:load_url_image/widgets/video_controller_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? controller;
  bool isVideoInitialize = false;

  @override
  void initState() {
    videoInitialize();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void videoInitialize() async {
    final previousVideoController = controller;
    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(
          "https://github.com/dicodingacademy/assets/releases/download/release-video/VideoDicoding.mp4"),
    );
    // final videoController = VideoPlayerController.asset(
    //   "assets/butterfly.mp4",
    // );
    await previousVideoController?.dispose();

    try {
      await videoController.initialize();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
    }

    if (mounted) {
      setState(() {
        controller = videoController;
        isVideoInitialize = controller!.value.isInitialized;
      });

      if (isVideoInitialize) {
        final provider = context.read<VideoProvider>();
        controller?.addListener(() {
          provider.duration = controller?.value.duration ?? Duration.zero;
          provider.position = controller?.value.position ?? Duration.zero;
          provider.isPlay = controller?.value.isPlaying ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player Project")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          isVideoInitialize
              ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(
                    controller!,
                  ),
                )
              : const CircularProgressIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<VideoProvider>(
                  builder: (context, provider, child) {
                    final duration = provider.duration;
                    final position = provider.position;

                    return BufferSliderControllerWidget(
                      maxValue: duration.inSeconds.toDouble(),
                      currentValue: position.inSeconds.toDouble(),
                      minText: durationToTimeString(position),
                      maxText: durationToTimeString(duration),
                      onChanged: (value) async {
                        final newPosition = Duration(seconds: value.toInt());
                        await controller?.seekTo(newPosition);
                        await controller?.play();
                      },
                    );
                  },
                ),
                Consumer<VideoProvider>(
                  builder: (context, provider, child) {
                    final isPlay = provider.isPlay;

                    return VideoControllerWidget(
                      onPlayTapped: () {
                        controller?.play();
                      },
                      onPauseTapped: () {
                        controller?.pause();
                      },
                      isPlay: isPlay,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
