import 'package:flutter/material.dart';
import 'google_maps.dart';
import 'driving_videos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Technology Fair', // マルチタスクボタンを押したときに表示されるバーのタイトル
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Sky Technology Fair'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool isPlay = true;
  static Icon icon = Icon(Icons.play_arrow);
  static String str = "Play";

  void _PushPlayBtn() {
    setState(() { // 画面再描画 Widget build(BuildContext context)が再度呼ばれる
      if (isPlay) {
        isPlay = false;
        icon = Icon(Icons.stop);
        str = "Stop";
        DrivingVideos("assets/driving.mp4").createState().play();
      }
      else {
        isPlay = true;
        icon = Icon(Icons.play_arrow);
        str = "Play";
        DrivingVideos("assets/driving.mp4").createState().stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final padding = MediaQuery
        .of(context)
        .padding;
    var maxHeight = size.height - padding.top - padding.bottom;

    // アプリ描画エリアの縦サイズを取得
    maxHeight = size.height - padding.top - kToolbarHeight;

    // Resultエリアの縦サイズ
    final mapAreaHeight = maxHeight * (50 / 100);
    // テンキーエリアの縦サイズ
    final videoAreaHeight = maxHeight * (50 / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: size.width,
              height: mapAreaHeight,
              child: GoogleMaps(),
            ),
            Container(
              width: size.width,
              height: videoAreaHeight,
              child: DrivingVideos("assets/driving.mp4"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _PushPlayBtn,
        tooltip: str,
        child: icon,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
