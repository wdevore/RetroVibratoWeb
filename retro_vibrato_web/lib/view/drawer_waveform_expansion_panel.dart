import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/field.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class WaveformSubPanel extends StatelessWidget {
  const WaveformSubPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<WaveformSettings>();

    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.white,
      animationDuration: const Duration(milliseconds: 150),
      expansionCallback: (int index, bool isExpanded) {
        if (isExpanded) {
          settings.expanded();
        } else {
          settings.collapsed();
        }
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: Colors.lime.shade100,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const Center(
              child: Text(
                "Waveforms",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          },
          body: Consumer<Field>(
            builder: (_, wtype, __) => Column(
              children: [
                TextButton(
                  child: Text(
                    'Square',
                    style: TextStyle(
                      color: wtype.value == WaveForm.square
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.square;
                  },
                ),
                TextButton(
                  child: Text(
                    'Triangle',
                    style: TextStyle(
                      color: wtype.value == WaveForm.triangle
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.triangle;
                  },
                ),
                TextButton(
                  child: Text(
                    'Sine',
                    style: TextStyle(
                      color: wtype.value == WaveForm.sine
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.sine;
                  },
                ),
                TextButton(
                  child: Text(
                    'Sawtooth Rising',
                    style: TextStyle(
                      color: wtype.value == WaveForm.sawtoothRising
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.sawtoothRising;
                  },
                ),
                TextButton(
                  child: Text(
                    'Sawtooth Falling',
                    style: TextStyle(
                      color: wtype.value == WaveForm.sawtoothFalling
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.sawtoothFalling;
                  },
                ),
                TextButton(
                  child: Text(
                    'White Noise',
                    style: TextStyle(
                      color: wtype.value == WaveForm.whiteNoise
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.whiteNoise;
                  },
                ),
                TextButton(
                  child: Text(
                    'Pink Noise',
                    style: TextStyle(
                      color: wtype.value == WaveForm.pinkNoise
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.pinkNoise;
                  },
                ),
                TextButton(
                  child: Text(
                    'Red Noise',
                    style: TextStyle(
                      color: wtype.value == WaveForm.redNoise
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    wtype.value = WaveForm.redNoise;
                  },
                ),
              ],
            ),
          ),
          isExpanded: settings.isExpanded,
        ),
      ],
    );
  }
}
