import 'dart:convert';
import 'dart:typed_data';

import 'package:retro_vibrato_web/configurations.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

//                OFFSET SIZE NOTES
// chunkId      : 0      4    "RIFF" = 0x52494646
// chunkSize    : 4      4    36+SubChunk2Size = 4+(8+SubChunk1Size)+(8+SubChunk2Size)
// format       : 8      4    "WAVE" = 0x57415645
// subChunk1Id  : 12     4    "fmt " = 0x666d7420
// subChunk1Size: 16     4    16 for PCM
// audioFormat  : 20     2    PCM = 1
// numChannels  : 22     2    Mono = 1, Stereo = 2...
// sampleRate   : 24     4    8000, 44100...
// byteRate     : 28     4    SampleRate*NumChannels*BitsPerSample/8
// blockAlign   : 32     2    NumChannels*BitsPerSample/8
// bitsPerSample: 34     2    8 bits = 8, 16 bits = 16
// subChunk2Id  : 36     4    "data" = 0x64617461
// subChunk2Size: 40     4    data size = NumSamples*NumChannels*BitsPerSample/8

class HeaderOffsets {
  static const chunkId = 0;
  static const chunkSize = 4;
  static const format = 8;
  static const subChunk1Id = 12;
  static const subChunk1Size = 16;
  static const audioFormat = 20;
  static const numChannels = 22;
  static const sampleRate = 24;
  static const byteRate = 28;
  static const blockAlign = 32;
  static const bitsPerSample = 34;
  static const subChunk2Id = 36;
  static const subChunk2Size = 40;
}

class Wave {
  List<int> wav = [];
  String dataURI = '';

  final Uint8List _header = Uint8List(0);

  int sampleRate = 0;
  int numChannels = 1;
  int bitsPerSample = 0;
  int audioFormat = 1; // 1 = PCM
  int subChunk1Size = 16; // 16 for PCM

  void init(Configurations config) {
    // Set control parms
    SettingsModel settings = config.settings;
    sampleRate = SettingsModel.sampleRateToInt(settings.appSettings);
    bitsPerSample = SettingsModel.sampleSizeToInt(settings.appSettings);

    // _header.addAll([
    //   0x52, 0x49, 0x46, 0x46, // Chunk Id
    //   0x0, 0x0, 0x0, 0x0, // chunkSize
    //   0x57, 0x41, 0x56, 0x45, // format
    //   0x66, 0x6d, 0x74, 0x20, // subChunk1 Id
    //   0x0, 0x0, 0x0, 0x10, // subChunk1Size = 16
    //   0x0, 0x01, // audioFormat = 1
    //   0x0, 0x01, // numChannels = 1
    //   0x0, 0x0, 0x1f, 0x40, // sampleRate = 8000
    //   0x0, 0x0, 0x00, 0x00, // byteRate = 0
    //   0x0, 0x0, // blockAlign = 0
    //   0x0, 0x08, // bitsPerSample = 8
    //   0x64, 0x61, 0x74, 0x61, // subChunk2 Id
    //   0x0, 0x0, 0x00, 0x00, // subChunk2Size = 0
    // ]);
  }

  void make(List<int> bufferData) {
    wav.clear();

    // int sampleRate = _getHeaderSampleRate();
    // int numChannels = _getHeaderNumChannels();
    // int bitsPerSample = _getHeaderBitsPerSample();

    int byteRate = (sampleRate * numChannels * bitsPerSample) >> 3;
    // _setByteRate(byteRate);

    int blockAlign = (numChannels * bitsPerSample) >> 3;
    // _setBlockAlign(blockAlign);

    int subChunk2Size = bufferData.length;
    // _setSubChunk2Size(data.length);
    // _setChunkSize(36 + data.length);

    // Build wav sequence
    wav.addAll([0x52, 0x49, 0x46, 0x46]); // Chunk Id
    // List<int> list8 = _toUint8List(36 + subChunk2Size);
    // List<int> xxx = u32ToArray(36 + subChunk2Size);
    wav.addAll(_intTo4Bytes(36 + subChunk2Size)); // Chunk size
    wav.addAll([0x57, 0x41, 0x56, 0x45]); // Format
    wav.addAll([0x66, 0x6d, 0x74, 0x20]); // Sub Chunk 1 Id
    wav.addAll(_intTo4Bytes(subChunk1Size)); // Sub Chunk 1 size
    wav.addAll(_intTo2Bytes(audioFormat)); // Audio format
    wav.addAll(_intTo2Bytes(numChannels)); // Number of Channels
    wav.addAll(_intTo4Bytes(sampleRate)); // Sample rate
    wav.addAll(_intTo4Bytes(byteRate)); // Byte rate
    wav.addAll(_intTo2Bytes(blockAlign)); // Block align
    wav.addAll(_intTo2Bytes(bitsPerSample)); // Bits per sample
    wav.addAll([0x64, 0x61, 0x74, 0x61]); // Sub Chunk 2 Id
    wav.addAll(_intTo4Bytes(subChunk2Size)); // Sub Chunk 2 size

    // Append wav sample data. The GA's buffer contains integer
    // clipped versions.
    Uint8List list = Uint8List(subChunk2Size);
    list.setRange(0, subChunk2Size, bufferData);
    wav.addAll(list.cast());
  }

  String wavToURI() {
    dataURI = 'data:audio/wav;base64,${base64Encode(wav)}';
    return dataURI;
  }

  List<int> _intTo4Bytes(int value32) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, value32, Endian.little);
    return buffer.asUint8List(); // implicit cast to List
  }

  List<int> _intTo2Bytes(int value16) {
    ByteBuffer buffer = Uint8List(2).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint16(0, value16, Endian.little);
    return buffer.asUint8List(); // implicit cast to List
  }

  List<int> _toUint32List(int value32) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, value32, Endian.little);
    return buffer.asUint32List();
  }

  List<int> _toUint16List(int value16) {
    ByteBuffer buffer = Uint8List(2).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint16(0, value16, Endian.little);
    return buffer.asUint16List();
  }

  // -------------------------------------------------------------------
  // Setters
  // -------------------------------------------------------------------
  void setSampleRate(int rate) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, rate);
    _header.setAll(HeaderOffsets.sampleRate, buffer.asUint32List());
  }

  void setNumChannels(int channels) {
    ByteBuffer buffer = Uint8List(2).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint16(0, channels);
    _header.setAll(HeaderOffsets.numChannels, buffer.asUint16List());
  }

  void setBitsPerSample(int bitsPer) {
    ByteBuffer buffer = Uint8List(2).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint16(0, bitsPer);
    _header.setAll(HeaderOffsets.bitsPerSample, buffer.asUint16List());
  }

  void _setByteRate(int rate) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, rate);
    _header.setAll(HeaderOffsets.byteRate, buffer.asUint32List());
  }

  void _setBlockAlign(int align) {
    ByteBuffer buffer = Uint8List(2).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint16(0, align);
    _header.setAll(HeaderOffsets.blockAlign, buffer.asUint16List());
  }

  void _setSubChunk2Size(int size) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, size);
    _header.setAll(HeaderOffsets.subChunk2Size, buffer.asUint32List());
  }

  void _setChunkSize(int size) {
    ByteBuffer buffer = Uint8List(4).buffer;
    ByteData bdata = ByteData.view(buffer);
    bdata.setUint32(0, size);
    _header.setAll(HeaderOffsets.chunkSize, buffer.asUint32List());
  }

  // -------------------------------------------------------------------
  // Getters
  // -------------------------------------------------------------------
  int _getHeaderSampleRate() {
    ByteData b = _getByteData(HeaderOffsets.sampleRate, HeaderOffsets.byteRate);

    int v = b.getInt32(0);
    return v;
  }

  int _getHeaderNumChannels() {
    ByteData b =
        _getByteData(HeaderOffsets.numChannels, HeaderOffsets.sampleRate);

    int v = b.getInt16(0);
    return v;
  }

  int _getHeaderBitsPerSample() {
    ByteData b =
        _getByteData(HeaderOffsets.bitsPerSample, HeaderOffsets.subChunk2Id);

    int v = b.getInt16(0);
    return v;
  }

  ByteData _getByteData(int startInclusive, intEndExclusive) {
    var range = _header.getRange(startInclusive, intEndExclusive).toList();
    Uint8List list8 = Uint8List.fromList(range);

    ByteData bd = ByteData.view(list8.buffer);
    return bd;
  }

  // This method is a direct translation from riffwave.js from jsfxr code.
  // This produces the same results as _toUint8List using Little endian.
  List<int> u32ToArray(i) {
    List<int> arr = [
      i & 0xFF,
      (i >> 8) & 0xFF,
      (i >> 16) & 0xFF,
      (i >> 24) & 0xFF,
    ];
    return arr;
  }

  List<int> u16ToArray(i) {
    return [i & 0xFF, (i >> 8) & 0xFF];
  }
}
