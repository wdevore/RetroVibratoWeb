import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mp_audio_stream/mp_audio_stream.dart';
import 'package:retro_vibrato_web/configurations.dart';

class PlayButtonStatelessWidget extends StatelessWidget {
  final Configurations conf;
  final AudioStream audioStream;

  const PlayButtonStatelessWidget({
    super.key,
    required this.conf,
    required this.audioStream,
  });
//-0.0038050466614640635
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(top: kToolbarHeight),
      child: FloatingActionButton(
        onPressed: () {
          debugPrint('Play');
          conf.config(); // init() and initForRepeat()
          conf.generate(); // = getRawBuffer

          // Convert normalized data to Float32List
          Float32List wave = Float32List.fromList(conf.ga.normalized);

          audioStream.init(bufferMilliSec: 1000, waitingBufferMilliSec: 100);

          // for web, calling `resume()` from user-action is needed
          audioStream.resume();

          // Stream it
          audioStream.push(wave);
        },
        tooltip: 'Play sound',
        backgroundColor: Colors.lime,
        child: const Icon(
          Icons.play_arrow,
          size: 50,
          color: Colors.blue,
        ),
      ),
    );
  }
}
