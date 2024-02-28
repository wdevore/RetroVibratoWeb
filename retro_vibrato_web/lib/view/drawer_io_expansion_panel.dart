import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro_vibrato_web/configurations.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';
import 'package:retro_vibrato_web/wave.dart';

class DrawerIOExpansionPanel extends StatefulWidget {
  const DrawerIOExpansionPanel({
    super.key,
    required this.settings,
    required this.conf,
  });

  final SettingsModel settings;
  final Configurations conf;

  @override
  DrawerIOExpansionPanelState createState() => DrawerIOExpansionPanelState();
}

class DrawerIOExpansionPanelState extends State<DrawerIOExpansionPanel> {
  bool _isExpanded = false;
  // We need these controllers to maintain values between drawer
  // collapse and expand.
  final TextEditingController _downloadController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _downloadController.text = widget.settings.downloadName ?? '';
    _nameController.text = widget.settings.appSettings.name.value ?? '';
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.white,
      animationDuration: const Duration(milliseconds: 150),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: Colors.lime.shade200,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const Center(
              child: Text(
                "I/O",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, top: 8.0, right: 0.0, bottom: 4.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Save/Download name',
                  ),
                  controller: _downloadController,
                  onSubmitted: (String value) {
                    widget.settings.downloadName = value;
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange.shade100),
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
                    _saveSfxr();
                    // Navigator.pop(context);
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
                    // Convert samples to Wave file
                    _saveWave(widget.conf);
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange.shade300),
                child: ListTile(
                  leading: const Icon(Icons.save_outlined),
                  title: const Text('Open Sfxr file',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  onTap: () async {
                    await _openSfxr();
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, top: 8.0, right: 0.0, bottom: 4.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of sound',
                  ),
                  controller: _nameController,
                  onSubmitted: (String value) {
                    widget.settings.appSettings.name.value = value;
                  },
                ),
              ),
            ],
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  void _saveWave(Configurations conf) {
    // audio/wave;base64,${content.toString('base64')
    // Create the link with the file
    // formatted as Riffwave
    // conf.pickUpOrCoin(true);
    // conf.tone(440, WaveForm.sine);
    // conf.mutate();
    conf.config(); // init() and initForRepeat()
    conf.generate(); // = getRawBuffer

    Wave wave = Wave();
    wave.init(conf);
    wave.make(conf.ga.buffer);

    String wavBase64 = wave.wavToURI();

    final anchor = AnchorElement(href: wavBase64)..target = 'blank';

    // add the name
    String name = widget.settings.downloadName ?? 'noName.wav';
    if (!name.contains('.wav')) {
      name += '.wav';
    }

    anchor.download = name;
    document.body!.append(anchor);

    // trigger download
    anchor.click();
    anchor.remove();
  }

  void _saveSfxr() {
    // Get json from settings
    String contents = widget.settings.toJson();

    // Create the link with the file
    final anchor = AnchorElement(href: 'data:text/plain,$contents')
      ..target = 'blank';

    // add the name
    String name = widget.settings.downloadName ?? 'noName.sfxr';
    if (!name.contains('.sfxr')) {
      name += '.sfxr';
    }

    anchor.download = name;
    document.body!.append(anchor);

    // You could also set download via attributes
    // ..setAttribute("download", "file.txt")

    // trigger download
    anchor.click();
    anchor.remove();

    return;
  }

  Future<void> _openSfxr() async {
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
        widget.settings.fromJson(jayson);
      }
    } else {
      // debugPrint("No file selected");
    }

    return;
  }
}
