import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';
import 'package:retro_vibrato_web/view/Arpeggiation_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/DutyCycle_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/Flanger_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/Retrigger_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/auto_play.dart';
import 'package:retro_vibrato_web/view/envelope_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/frequency_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/highPassFilter_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/lowPassFilter_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/sample_rate.dart';
import 'package:retro_vibrato_web/view/vibrato_expansion_panel_list.dart';

SettingsModel _settings = SettingsModel();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    return MaterialApp(
      title: 'RetroVibrato',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const FSfxrHomePage(title: 'Retro Vibrato'),
    );
  }
}

class FSfxrHomePage extends StatelessWidget {
  const FSfxrHomePage({super.key, required this.title});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: _buildAppBar(context, title),
        drawer: _buildDrawer(context),
        body: ListView(children: [
          ChangeNotifierProvider.value(
            value: _settings.envelopeSettings,
            child: const EnvelopeExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.frequencySettings,
            child: const FrequencyExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.vibratoSettings,
            child: const VibratoExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.arpeggiationSettings,
            child: const ArpeggiationExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.dutyCycleSettings,
            child: const DutyCycleExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.retriggerSettings,
            child: const RetriggerExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.flangerSettings,
            child: const FlangerExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.lowPassFilterSettings,
            child: const LowPassFilterExpansionPanelList(),
          ),
          ChangeNotifierProvider.value(
            value: _settings.highPassFilterSettings,
            child: const HighPassFilterExpansionPanelList(),
          ),
        ]),
        // Place play button in the top right corner
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: const PlayButtonStatelessWidget());
  }

  // Basic title bar
  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.black54,
      foregroundColor: Colors.orange[300],
      // Here we take the value from the HomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
    );
  }

  // Slide-out screen widget
  Drawer _buildDrawer(BuildContext context) {
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: kToolbarHeight + 40,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.black54),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Retro Vibrato',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
              ),
              child: ListTile(
                leading: const Icon(Icons.save_outlined),
                title: const Text(
                  'Save as *.Sfxr',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  // Save and close drawer
                  debugPrint('Tapped');
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.orange.shade200),
              child: ListTile(
                leading: const Icon(Icons.save_outlined),
                title: const Text('Save as *.wav',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.orange.shade200),
              child: ListTile(
                leading: const Icon(Icons.save_outlined),
                title: const Text('Open Sfxr file',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
                onTap: () {
                  // Then close the drawer
                  _openSfxr();
                  Navigator.pop(context);
                },
              ),
            ),
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.sampleRateSettings,
                ),
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.sampleRateSettings.rate,
                ),
              ],
              child: const SettingsSampleRateSubPanel(),
            ),
            ChangeNotifierProvider.value(
              value: _settings.appSettings.autoplay,
              child: const SettingsAutoplayCheck(),
            ),
          ],
        ),
      ),
    );
  }

  void _openSfxr() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // onFileLoading: (FilePickerStatus status) =>
      //     debugPrint('Pick status: $status'),
      allowedExtensions: ['json'],
    );

    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;

      AsciiDecoder decoder = const AsciiDecoder();
      if (bytes != null) {
        String jayson = decoder.convert(bytes.toList());
        Map<String, dynamic> valueMap = json.decode(jayson);
      }

      // debugPrint('debug');
    } else {
      // debugPrint("No file selected");
    }
  }
}

class PlayButtonStatelessWidget extends StatelessWidget {
  const PlayButtonStatelessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(top: kToolbarHeight),
      child: FloatingActionButton(
        onPressed: () {
          // var counter = context.read<Counter>();
          // counter.increment();
          // debugPrint('Play');
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
