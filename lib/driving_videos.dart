import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DrivingVideos extends StatefulWidget {
  String movieURL; // 動画URL
  DrivingVideos(this.movieURL) : super();

  @override
  _DrivingVideosState createState() => _DrivingVideosState();
}

class _DrivingVideosState extends State<DrivingVideos> {
  static VideoPlayerController _controller = null; // コントローラー

  @override
  void initState() {
    // 動画プレーヤーの初期化
    if (null == _controller) {
      _controller = VideoPlayerController.asset(widget.movieURL);
      _controller.setLooping(true);
      _controller.initialize().then((_) {
        // 最初のフレームを描画するため初期化後に更新
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void play() {
    if (_controller.value.initialized) {
      _controller.play();
    }
  }

  void stop() {
    if (_controller.value.initialized) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null == _controller) {
      return Container();
    }
    if (_controller.value.initialized) {
      // 初期化完了していたら動画を停止状態で表示
      return Container(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    }
    else {
      // 初期化が完了していなければインジケータを表示
      return Container(
        height: 150.0,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }
  }
}