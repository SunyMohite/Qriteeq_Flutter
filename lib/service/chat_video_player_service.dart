import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayerService extends StatefulWidget {
  final String url;

  const ChatVideoPlayerService({Key? key, required this.url}) : super(key: key);

  @override
  State<ChatVideoPlayerService> createState() => _ChatVideoPlayerServiceState();
}

class _ChatVideoPlayerServiceState extends State<ChatVideoPlayerService> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: 0.8,
            child: VideoPlayer(
              _controller,
              key: UniqueKey(),
            ),
          )
        : Container(
            height: 50.w,
            width: 50.w,
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
