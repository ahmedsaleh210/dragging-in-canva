import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioWaveExtractor extends StatefulWidget {
  const AudioWaveExtractor({super.key});

  @override
  State<AudioWaveExtractor> createState() => _AudioWaveExtractorState();
}

class _AudioWaveExtractorState extends State<AudioWaveExtractor> {
  late PlayerController _controller;
  late StreamSubscription<PlayerState> playerStateSubscription;
  bool _isPlayed = false;

  @override
  void initState() {
    _init();
    _controller = PlayerController();

    playerStateSubscription = _controller.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.initialized) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.stopPlayer();
    _controller.dispose();
    playerStateSubscription.cancel();
    super.dispose();
  }

  static const double containerMargin = 10;

  Future<String> _getNetworkAudio() async {
    final uri =
        Uri.parse('https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav');
    final audioFile =
        File(p.join((await getTemporaryDirectory()).path, 'waveform.mp3'));
    final fileAudio = await audioFile.writeAsBytes(
        (await NetworkAssetBundle(uri).load(uri.toString()))
            .buffer
            .asUint8List());
    return fileAudio.path;
  }

  Future<void> _init() async {
    try {
      final audio = await _getNetworkAudio();
      await _controller.preparePlayer(
        path: audio,
        shouldExtractWaveform: true,
        noOfSamples: playerWaveStyle
            .getSamplesForWidth(MediaQuery.of(context).size.width - containerMargin * 2),
        volume: 1.0,
      );
    } on PlatformException catch (e) {
      debugPrint('Error: $e');
    }
  }

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.grey,
    liveWaveColor: Colors.blue,
    seekLineColor: Colors.blue,
    scaleFactor: 500,
    showSeekLine: false,
    spacing: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: containerMargin),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200]),
                  child: AudioFileWaveforms(
                      playerController: _controller,
                      size: Size(MediaQuery.of(context).size.width, 100.0),
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: playerWaveStyle),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_isPlayed) {
                        _controller.pausePlayer();
                      } else {
                        _controller.startPlayer(
                          finishMode: FinishMode.loop,
                        );
                      }
                      setState(() {
                        _isPlayed = !_isPlayed;
                      });
                    },
                    child: Text(_isPlayed ? 'Stop' : 'Play')),
              ],
            ),
          )),
    );
  }
}
