import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  double _currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
    )..initialize().then((_) {
        setState(() {
          // Video is initialized, you can play it now.
        });
      });

    _videoController.addListener(() {
      setState(() {
        _currentPosition = _videoController.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _playPauseVideo() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  var activerDST = true;

  void _seekForward() {
    final newPosition = _currentPosition + 10.0;
    _videoController.seekTo(Duration(seconds: newPosition.toInt()));
  }

  void _seekBackward() {
    final newPosition = _currentPosition - 10.0;
    _videoController.seekTo(Duration(seconds: newPosition.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player App'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            activerDST = !activerDST;
            setState(() {});
          },
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 4 / 3,
                // You may need to adjust this for your video aspect ratio.
                child: VideoPlayer(_videoController),
              ),
              Positioned.fill(
                child: Stack(
                  children: [
                    if (activerDST)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.replay_10,
                                color: Colors.white,
                                size: 36,
                              ),
                              onPressed: _seekBackward,
                            ),
                            IconButton(
                              icon: Icon(
                                _videoController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                              onPressed: _playPauseVideo,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Colors.white,
                                size: 36,
                              ),
                              onPressed: _seekForward,
                            ),
                          ],
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ValueListenableBuilder(
                          valueListenable: _videoController,
                          builder: (context, value, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Slider(
                                    value: value.position.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      _videoController.seekTo(
                                          Duration(seconds: value.toInt()));
                                    },
                                    min: 0.0,
                                    max: value.duration.inSeconds.toDouble(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(positionToTime((value.position))),
                                      Text(positionToTime((value.duration - value.position) ))
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                )
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String positionToTime(Duration duration) {
    final hours = duration.inHours;
    final minute = duration.inMinutes.remainder(60);
    final second = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "$hours:$minute:$second";
    }

    return "$minute:$second";
  }
}