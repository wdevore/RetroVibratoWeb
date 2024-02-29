import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/configurations.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';
import 'package:retro_vibrato_web/view/Arpeggiation_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/DutyCycle_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/Flanger_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/Retrigger_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/auto_play.dart';
import 'package:retro_vibrato_web/view/drawer_generator_expansion_panel.dart';
import 'package:retro_vibrato_web/view/drawer_io_expansion_panel.dart';
import 'package:retro_vibrato_web/view/drawer_waveform_expansion_panel.dart';
import 'package:retro_vibrato_web/view/envelope_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/frequency_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/highPassFilter_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/lowPassFilter_expansion_panel_list.dart';
import 'package:retro_vibrato_web/view/play_button_stateless_widget.dart';
import 'package:retro_vibrato_web/view/sample_rate.dart';
import 'package:retro_vibrato_web/view/sample_size.dart';
import 'package:retro_vibrato_web/view/settings_slider.dart';
import 'package:retro_vibrato_web/view/vibrato_expansion_panel_list.dart';

final SettingsModel _settings = SettingsModel();
final Configurations _conf = Configurations(_settings);

// UI gen
//   pickUpCoin
// UI updateUI
// UI play
//   SoundEffect constructor
//     SoundEffect.init            ---|
//       SoundEffect.initForRepeat ---| config
//   SoundEffect.generate
//     SoundEffect.getRawBuffer
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
      floatingActionButton: PlayButtonStatelessWidget(
        conf: _conf,
      ),
    );
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
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.generatorSettings,
                ),
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.generatorSettings.type,
                ),
              ],
              child:
                  GeneratorsSubPanel(configurations: Configurations(_settings)),
            ),
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.waveformSettings,
                ),
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.waveformSettings.type,
                ),
              ],
              child: const WaveformSubPanel(),
            ),
            ChangeNotifierProvider.value(
              value: _settings.appSettings.volume,
              child: const SettingsSlider(
                height: 40,
                flex: 3,
              ),
            ),
            DrawerIOExpansionPanel(
              settings: _settings,
              conf: _conf,
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
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.sampleSizeSettings,
                ),
                ChangeNotifierProvider.value(
                  value: _settings.appSettings.sampleSizeSettings.size,
                ),
              ],
              child: const SettingsSampleSizeSubPanel(),
            ),
            ChangeNotifierProvider.value(
              value: _settings.appSettings.autoplay,
              child: const SettingsAutoplayCheck(),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.lime.shade400),
              child: ListTile(
                leading: const Icon(Icons.help),
                title: const Text('About',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
                onTap: () {
                  // Show dialog
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
