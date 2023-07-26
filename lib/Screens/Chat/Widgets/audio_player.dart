import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:orghub/Helpers/app_theme.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audio;
  AudioPlayerWidget({@required this.audio});
  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerWidgetState();
  }
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer audioPlayer;
  bool _isPlaying = false;
  Duration _position;
  initState() {
    audioPlayer = new AudioPlayer();
    audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        _isPlaying = false;
      });
    });
    super.initState();
  }

  get _positionText => _position?.toString()?.split('.')?.first ?? '0:00:00';

  play() async {
    int result = await audioPlayer.play(widget.audio);
    if (result == 1) {
      // success
      print("audio running");
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  pause() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  stop() async {
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(width: 10),
          // InkWell(
          //   onTap:()async{await audioPlayer.pause();},
          //   child: Icon(Icons.pause),
          // ),
          // InkWell(
          //   onTap:()async{await audioPlayer.stop();},
          //   child: Icon(Icons.stop),
          // ),
          Text(
            _positionText,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontFamily: "Neosans",
              fontSize: 15,
            ),
          ),
          InkWell(
            onTap: _isPlaying ? pause : play,
            child: _isPlaying
                ? Icon(
                    Icons.pause,
                    size: 40,
                    color: AppTheme.primaryColor,
                  )
                : Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
          ),
        ],
      ),
    );
  }
}
