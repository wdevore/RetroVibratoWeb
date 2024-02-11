import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class SettingsSampleRateSubPanel extends StatelessWidget {
  const SettingsSampleRateSubPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SampleRateSettings>();

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
          backgroundColor: Colors.lime.shade200,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const Center(
              child: Text(
                "Sample Rate",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          },
          body: Consumer<Field>(
            builder: (_, rate, __) => Column(
              children: [
                RadioListTile<SampleRate>(
                  title: const Text('44 KHz',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleRate.kHz44,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleRate? value) {
                    rate.value = value;
                  },
                ),
                RadioListTile<SampleRate>(
                  title: const Text('22 KHz',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleRate.kHz22,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleRate? value) {
                    rate.value = value;
                  },
                ),
                RadioListTile<SampleRate>(
                  title: const Text('11 KHz',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleRate.kHz11,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleRate? value) {
                    rate.value = value;
                  },
                ),
                RadioListTile<SampleRate>(
                  title: const Text('5.5 KHz',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleRate.kHz55,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleRate? value) {
                    rate.value = value;
                  },
                )
              ],
            ),
          ),
          isExpanded: settings.isExpanded,
        ),
      ],
    );
  }
}
