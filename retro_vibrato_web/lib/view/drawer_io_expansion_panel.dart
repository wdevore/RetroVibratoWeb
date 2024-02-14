import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class DrawerIOExpansionPanel extends StatefulWidget {
  const DrawerIOExpansionPanel({
    super.key,
    required this.settings,
  });

  final SettingsModel settings;

  @override
  DrawerIOExpansionPanelState createState() => DrawerIOExpansionPanelState();
}

class DrawerIOExpansionPanelState extends State<DrawerIOExpansionPanel> {
  bool _isExpanded = false;

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
                    left: 0.0, top: 6.0, right: 0.0, bottom: 4.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Save/Download name',
                  ),
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
                decoration: BoxDecoration(color: Colors.orange.shade300),
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
            ],
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  void _saveSfxr() {
    // Get text version from settings
    String contents = """
      {
          "Format": "InternalView",
          "Category": "Random",
          "Name": "Tone3",
          "BaseFrequency": 1.293542900416264,
      }
      """;

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
        widget.settings.fromJson(jayson);
      }
    } else {
      // debugPrint("No file selected");
    }
  }
}
