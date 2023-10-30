import 'package:flutter/material.dart';
import 'package:toktik/presentation/widgets/video/video_backgound.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  const FullScreenPlayer({super.key, required this.videoUrl, required this.caption});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..setVolume(0)
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done){
          return const Center(child: CircularProgressIndicator(strokeWidth: 2,),);
        } 

        return GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying){
              _controller.pause();
              return;
            } 
            _controller.play();
          },
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                //VIDEO
                VideoPlayer(_controller),
                //GRADIENTE
                const VideoBackground(stops: [0.8,1.0]),
                //TEXTO
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: VideoCapture(caption: widget.caption),
                )
              ],
            )
          ),
        );

      },
    );
  }
}

class VideoCapture extends StatelessWidget {
  final String caption;
  const VideoCapture({super.key, required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tittleStyle = Theme.of(context).textTheme.titleLarge;
    return SizedBox(
      width: size.width * 0.6,
      child: Text( caption, maxLines: 2, style: tittleStyle),
    );
  }
}