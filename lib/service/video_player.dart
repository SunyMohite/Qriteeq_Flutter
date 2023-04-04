import 'dart:io';

import 'package:flutter/material.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService extends StatefulWidget {
  final String url;
  final bool isLocal;

  const VideoPlayerService({Key? key, required this.url, this.isLocal = false})
      : super(key: key);

  @override
  State<VideoPlayerService> createState() => _VideoPlayerServiceState();
}

class _VideoPlayerServiceState extends State<VideoPlayerService> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.isLocal) {
      _controller = VideoPlayerController.file(File(widget.url))
        ..initialize().then((_) {

          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.network(widget.url)

        ..initialize().then((_) {
          setState(() {});
        });
    }

    _controller.setLooping(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isPlayVideo = false;
  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? InkWell(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
                isPlayVideo = false;
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(
                    _controller,
                    key: widget.key,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                      child: VideoProgressIndicator(_controller,
                          colors: const VideoProgressColors(
                              playedColor: ColorUtils.primaryColor,
                              backgroundColor: Colors.white),
                          allowScrubbing: true)),
                  AnimatedOpacity(
                    opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 50.w,
            width: double.infinity,
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
