import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/field.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class SettingsSampleSizeSubPanel extends StatelessWidget {
  const SettingsSampleSizeSubPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SampleSizeSettings>();

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
          backgroundColor: Colors.lime.shade300,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const Center(
              child: Text(
                "Sample Size",
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
                RadioListTile<SampleSize>(
                  title: const Text('16 Bits',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleSize.bits16,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleSize? value) {
                    rate.value = value;
                  },
                ),
                RadioListTile<SampleSize>(
                  title: const Text('8 Bits',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      )),
                  value: SampleSize.bits8,
                  dense: true,
                  groupValue: rate.value,
                  onChanged: (SampleSize? value) {
                    rate.value = value;
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
