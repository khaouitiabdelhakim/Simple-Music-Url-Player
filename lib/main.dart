import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Music Player'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0), // Add padding to the entire body
          child: MusicPlayer(),
        ),
      ),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = '';
  String songUrl = '';
  Duration duration = Duration();
  Duration position = Duration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20.0), // Add margin to the text widget
          child: Text(
            currentSong,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          margin: EdgeInsets.only(bottom: 20.0), // Add margin to the text form field
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter song URL',
            ),
            onChanged: (value) {
              setState(() {
                songUrl = value;
              });
            },
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 50.0,
              onPressed: () {
                if (!isPlaying && songUrl.isNotEmpty) {
                  play(songUrl);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.pause),
              iconSize: 50.0,
              onPressed: () {
                if (isPlaying) {
                  pause();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              iconSize: 50.0,
              onPressed: () {
                stop();
              },
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Container(
          margin: EdgeInsets.only(bottom: 20.0), // Add margin to the text widget
          child: Text(
            '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
          ),
        ),
        Slider(
          value: position.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSeconds(value.toInt());
          },
          min: 0.0,
          max: duration.inSeconds.toDouble(),
        ),
      ],
    );
  }

  void play(String url) {
    audioPlayer.play(url);
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    setState(() {
      isPlaying = true;
      currentSong = 'Now Playing: Your Song';
    });
  }

  void pause() {
    audioPlayer.pause();
    setState(() {
      isPlaying = false;
      currentSong = 'Paused: Your Song';
    });
  }

  void stop() {
    audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentSong = 'Stopped';
    });
  }

  void seekToSeconds(int seconds) {
    Duration newPosition = Duration(seconds: seconds);
    audioPlayer.seek(newPosition);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
