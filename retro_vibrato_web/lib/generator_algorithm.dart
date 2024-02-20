import 'dart:math';

import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class GeneratorAlgorithm {
  static const noiseBufferSize = 32;
  static const flangerBufferSize = 1024;
  // Basic oversampling
  static const standardOverSamplings = 8;

  // --------------------------------
  // ADSR stages
  // --------------------------------
  // Attack part of envelope
  static const envelopeAttack = 0;
  // Sustain part of envelope
  static const envelopeSustain = 1;
  // Decay part of envelope
  static const envelopeDecay = 2;
  // Release part of envelope
  static const envelopeRelease = 3;

  List<int> envelopeLength = [];
  double envelopePunch = 0;

  WaveForm prevWaveShape = WaveForm.none;
  WaveForm waveShape = WaveForm.none;

  int elapsedSinceRepeat = 0;

  double period = 0.0;
  double periodMax = 0.0;
  bool enableFrequencyCutoff = false;
  double periodMult = 0.0;
  double periodMultSlide = 0.0;

  double dutyCycle = 0.0;
  double dutyCycleSlide = 0.0;

  double arpeggioMultiplier = 0.0;
  int arpeggioTime = 0;

  int repeatTime = 0;

  // Filter
  double fltw = 0.0;
  bool enableLowPassFilter = false;

  // Repeat
  double fltwD = 0.0;
  double fltdmp = 0.0;
  double flthp = 0.0;
  double flthpD = 0.0;

  // Vibrato and Repeat
  double vibratoSpeed = 0.0;
  double vibratoAmplitude = 0.0;

  // Flanger and Repeat
  double flangerOffset = 0.0;
  double flangerOffsetSlide = 0.0;

  List<double> samples = [];

  void setSubsectionP(SettingsModel settings) {
    var frequencySettings = settings.frequencySettings;
    var baseFreq = frequencySettings.frequency.value;
    var freqLimit = frequencySettings.minCutoff.value;

    period = 100.0 / (baseFreq * baseFreq + 0.001);

    var freqRamp = frequencySettings.slide.value;
    periodMax = 100.0 / (freqLimit * freqLimit + 0.001);
    enableFrequencyCutoff = (freqLimit > 0.0);
    periodMult = 1.0 - pow(freqRamp, 3) * 0.01;
    periodMultSlide = -pow(freqRamp, 3) * 0.000001;
  }

  void setSubsectionD(SettingsModel settings) {
    var duty = settings.dutyCycleSettings.dutyCycle.value;
    var dutyRamp = settings.dutyCycleSettings.sweep.value;
    dutyCycle = 0.5 - duty * 0.5;
    dutyCycleSlide = -dutyRamp * 0.00005;
  }

  void setSubsectionA(SettingsModel settings) {
    var arpMod = settings.arpeggiationSettings.multiplier.value;

    if (arpMod >= 0.0) {
      arpeggioMultiplier = 1 - pow(arpMod, 2) * 0.9;
    } else {
      arpeggioMultiplier = 1 + pow(arpMod, 2) * 10.0;
    }

    var arpSpeed = settings.arpeggiationSettings.speed.value;
    arpeggioTime = ((pow(1 - arpSpeed, 2) * 20000 + 32).floor()).toInt();
    if (arpSpeed == 1) {
      arpeggioTime = 0;
    }
  }

  void setSubsectionS(SettingsModel settings) {
    var repeatSpeed = settings.retriggerSettings.rate.value;
    repeatTime = ((pow(1.0 - repeatSpeed, 2.0) * 20000.0).floor()).toInt() + 32;
    if (repeatSpeed == 0.0) {
      repeatTime = 0;
    }
  }

  void setSubsectionL(SettingsModel settings) {
    var lowPassFreq = settings.lowPassFilterSettings.cutoffFreq.value;
    enableLowPassFilter = lowPassFreq != 1.0;
  }

  void initForRepeat(SettingsModel settings) {
    elapsedSinceRepeat = 0;

    setSubsectionP(settings); // Period
    setSubsectionD(settings); // Duty
    setSubsectionA(settings); // Arpeggio
    setSubsectionS(settings); // Repeat
    setSubsectionL(settings); // Low pass
  }

  void setForRepeat(SettingsModel settings) {
    elapsedSinceRepeat = 0;

    var attack = settings.envelopeSettings.attack;
    var sustain = settings.envelopeSettings.sustain;
    var decay = settings.envelopeSettings.decay;

    envelopeLength.addAll([
      ((attack.value * attack.value * 100000.0).floor()).toInt(),
      ((sustain.value * sustain.value * 100000.0).floor()).toInt(),
      ((decay.value * decay.value * 100000.0).floor()).toInt(),
    ]);

    envelopePunch = settings.envelopeSettings.punch.value;

    prevWaveShape = waveShape;
    waveShape = settings.appSettings.waveformSettings.type.value;

    setSubsectionP(settings);
    setSubsectionD(settings);
    setSubsectionA(settings);

    // Vibrato
    var vibratoSettings = settings.vibratoSettings;
    vibratoSpeed = pow(vibratoSettings.speed.value, 2.0) * 0.01;
    vibratoAmplitude = vibratoSettings.depth.value * 0.5; // Strength

    // Flanger
    var flangerSettings = settings.flangerSettings;

    flangerOffset = pow(flangerSettings.offset.value, 2.0) * 1020.0;
    if (flangerSettings.offset.value < 0.0) {
      flangerOffset = -flangerOffset;
    }
    flangerOffsetSlide = pow(flangerSettings.sweep.value, 2.0) * 1.0;
    if (flangerSettings.sweep.value < 0.0) {
      flangerOffsetSlide = -flangerOffsetSlide;
    }

    // Filter
    var lpfSettings = settings.lowPassFilterSettings;
    fltw = pow(lpfSettings.cutoffFreq.value, 3.0) * 0.1;
    enableLowPassFilter = lpfSettings.cutoffFreq.value != 1.0;
    fltwD = 1.0 + lpfSettings.cutoffSweep.value * 0.0001;
    fltdmp = 5.0 /
        (1.0 + pow(lpfSettings.resonance.value, 2.0) * 20.0) *
        (0.01 + fltw);
    if (fltdmp > 0.8) {
      fltdmp = 0.8;
    }

    var hpfSettings = settings.highPassFilterSettings;
    flthp = pow(hpfSettings.cutoffFreq.value, 2.0) * 0.1;
    flthpD = 1.0 + hpfSettings.cutoffSweep.value * 0.0003;
  }

  void generate(SettingsModel settings) {
    var noise = settings.noiseBuffer;
    final volume = settings.appSettings.volume.value;

    initForRepeat(settings);

    // If the noise buffer is empty or the wave shape has changed to noise
    // then build a noise buffer that can be blended in.
    if (waveShape != prevWaveShape || noise.isEmpty) {
      if (waveShape == WaveForm.whiteNoise ||
          waveShape == WaveForm.pinkNoise ||
          waveShape == WaveForm.redNoise) {
        noise = generateNoise(waveShape);
        settings.noiseBuffer = noise;
      } else {
        noise = []; // Clear buffer
        settings.noiseBuffer = [];
      }
    }

    int envelopeStage = 0;
    int envelopeElapsed = 0;

    double vibratoPhase = 0.0;

    int phase = 0;
    int flangerIndex = 0;

    final flangerBuffer = List<double>.filled(flangerBufferSize, 0.0);
    double sampleSum = 0.0;
    int numSummed = 0;
    int sampleRate = settings.appSettings.sampleRateSettings.rate.value;
    int summands = ((44100.0 / (sampleRate).toDouble()).floor()).toInt();

    for (var t = 0;; t++) {
      elapsedSinceRepeat++;

      if (repeatTime != 0 && elapsedSinceRepeat >= repeatTime) {
        initForRepeat(settings);
      }

      // -----------------------------
      // Arpeggio (single)
      // -----------------------------
      if (arpeggioTime != 0 && t >= arpeggioTime) {
        arpeggioTime = 0;
        period *= arpeggioMultiplier;
      }

      // -----------------------------
      // Frequency slide, and frequency slide slide!
      // -----------------------------
      periodMult += periodMultSlide;
      period *= periodMult;
      if (period > periodMax) {
        period = periodMax;
        if (enableFrequencyCutoff) {
          break;
        }
      }

      // -----------------------------
      // Vibrato
      // -----------------------------
      double rfperiod = period;
      if (vibratoAmplitude > 0.0) {
        vibratoPhase += vibratoSpeed;
        rfperiod = period * (1.0 + sin(vibratoPhase) * vibratoAmplitude);
      }

      int iPeriod = ((rfperiod).floor()).toInt();
      if (iPeriod < standardOverSamplings) {
        iPeriod = standardOverSamplings;
      }

      // -----------------------------
      // Square/Sawtooth/Triangle wave duty cycle
      // -----------------------------
      dutyCycle += dutyCycleSlide;
      dutyCycle = dutyCycle.clamp(0.0, 0.5);

      // -----------------------------
      // Volume envelope
      // -----------------------------
      envelopeElapsed++;
      if (envelopeElapsed > envelopeLength[envelopeStage]) {
        envelopeElapsed = 0;
        envelopeStage++;
        if (envelopeStage > envelopeDecay) {
          break; // Hit Release stage
        }
      }

      double envelopeVolume = 0.0;
      if (envelopeLength[envelopeStage] != 0) {
        envelopeVolume = envelopeElapsed.toDouble() /
            envelopeLength[envelopeStage].toDouble(); // Envelope Attack
      }

      switch (envelopeStage) {
        case envelopeAttack:
        case envelopeSustain:
          envelopeVolume = 1.0 + (1.0 - envelopeVolume) * 2.0 * envelopePunch;
        case envelopeDecay:
          envelopeVolume = 1.0 - envelopeVolume;
      }

      // -----------------------------
      // Flanger step
      // -----------------------------
      flangerOffset += flangerOffsetSlide;
      flangerOffset.floor().abs().toInt();
      int iPhase = flangerOffset.floor().abs().toInt();
      if (iPhase > flangerBufferSize - 1) {
        iPhase = flangerBufferSize - 1;
      }

      if (flthpD != 0.0) {
        flthp *= flthpD;
        flthp = flthp.clamp(0.00001, 0.1);
      }

      // -----------------------------
      // Sampling
      // -----------------------------
      // The final sample after oversamplin
      double sample = 0.0;

      // Use Oversampling to calculate the final sample
      for (var si = 0; si < standardOverSamplings; si++) {
        phase++;

        if (phase >= iPeriod) {
          phase %= iPeriod;
          if (waveShape == WaveForm.whiteNoise) {
            for (var i = 0; i < noiseBufferSize; i++) {
              noise[i] = Random().nextDouble() * 2.0 - 1.0;
            }
          }
        }

        double subSample = 0.0;

        // Base waveform
        double fp = phase.toDouble() / iPeriod.toDouble();

        switch (waveShape) {
          case WaveForm.square:
            if (fp < dutyCycle) {
              subSample = 0.5;
            } else {
              subSample = -0.5;
            }
          case WaveForm.triangle:
            if (fp < dutyCycle) {
              subSample = -1.0 + 2.0 * fp / dutyCycle;
            } else {
              subSample = 1.0 - 2.0 * (fp - dutyCycle) / (1.0 - dutyCycle);
            }
          case WaveForm.sawtoothRising:
            subSample = -1.0 + 1.0 * fp / dutyCycle; // Rising (default)
          case WaveForm.sawtoothFalling:
            subSample = 1.0 - 2.0 * (fp - dutyCycle) / (1.0 - dutyCycle);
          case WaveForm.sine:
            subSample = sin(fp * 2.0 * pi);
          case WaveForm.whiteNoise:
          case WaveForm.pinkNoise:
          case WaveForm.redNoise:
            subSample = noise[(phase * noiseBufferSize ~/ iPeriod)];
          default:
            subSample = sin(fp * 2.0 * pi); // default. TODO raise error
        }

        double filterPass = 0.0;
        double fltdp = 0.0;
        double filterPassHigh = 0.0;

        // -----------------------------
        // Low-pass filter
        // -----------------------------
        double pp = filterPass;
        fltw *= fltwD;
        fltw = fltw.clamp(0.0, 0.1);
        if (enableLowPassFilter) {
          fltdp += (subSample - filterPass) * fltw;
          fltdp -= fltdp * fltdmp;
        } else {
          filterPass = subSample;
          fltdp = 0.0;
        }
        filterPass += fltdp;

        // -----------------------------
        // High-pass filter
        // -----------------------------
        filterPassHigh += filterPass - pp;
        filterPassHigh -= filterPassHigh * flthp;
        subSample = filterPassHigh;

        // -----------------------------
        // Flanger
        // -----------------------------
        flangerBuffer[flangerIndex & (flangerBufferSize - 1)] = subSample;
        subSample += flangerBuffer[(flangerIndex - iPhase + flangerBufferSize) &
            (flangerBufferSize - 1)];
        flangerIndex = (flangerIndex + 1) & (flangerBufferSize - 1);

        // final accumulation and envelope application
        sample += subSample * envelopeVolume;
      }

      // Accumulate sub-samples appropriately for sample rate
      sampleSum += sample;
      numSummed++;
      if (numSummed >= summands) {
        numSummed = 0;
        sample = sampleSum / summands.toDouble();
        sampleSum = 0.0;
      } else {
        continue;
      }

      // Reference O'Reilly's WebAudio book for Volume verses Gain.
      sample = sample / standardOverSamplings.toDouble(); // * MASTER_VOLUME;
      sample *= volume;

      // if sample < -1 {
      // 	sample = -1
      // }
      // if sample > 1 {
      // 	sample = 1
      // }
      // fmt.Println(sample)
      samples.add(sample);
    }
  }

  List<double> generateNoise(WaveForm shape) {
    List<double> buffer = List.filled(noiseBufferSize, 0.0);

    switch (shape) {
      case WaveForm.whiteNoise:
        // Noise between [-1.0, 1.0]
        for (var i = 0; i < noiseBufferSize; i++) {
          buffer[i] = Random().nextDouble() * 2.0 - 1.0;
        }
      case WaveForm.pinkNoise:
        double b0 = 0.0;
        double b1 = 0.0;
        double b2 = 0.0;
        double b3 = 0.0;
        double b4 = 0.0;
        double b5 = 0.0;
        double b6 = 0.0;
        for (var i = 0; i < noiseBufferSize; i++) {
          double white = Random().nextDouble() * 2.0 - 1.0;
          b0 = 0.99886 * b0 + white * 0.0555179;
          b1 = 0.99332 * b1 + white * 0.0750759;
          b2 = 0.96900 * b2 + white * 0.1538520;
          b3 = 0.86650 * b3 + white * 0.3104856;
          b4 = 0.55000 * b4 + white * 0.5329522;
          b5 = -0.7616 * b5 - white * 0.0168980;
          buffer[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362;
          buffer[i] *= 0.11; // (roughly) compensate for gain
          buffer[i] = buffer[i].clamp(-1.0, 1.0);
          b6 = white * 0.115926;
        }
      case WaveForm.redNoise: // Brownian
        double lastOut = 0.0;
        for (var i = 0; i < noiseBufferSize; i++) {
          double white = Random().nextDouble() * 2.0 - 1.0;
          buffer[i] = Random().nextDouble() * 2.0 - 1.0;
          buffer[i] = (lastOut + (0.02 * white)) / 1.02;
          lastOut = buffer[i];
          buffer[i] *= 3.5; // (roughly) compensate for gain
          buffer[i] = buffer[i].clamp(-1.0, 1.0);
        }
      default:
        break;
    }

    return buffer;
  }
}
