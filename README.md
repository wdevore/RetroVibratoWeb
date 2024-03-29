# RetroVibratoWeb
A web version RetroVibrato that it in turn is based off of [jsfxr](https://sfxr.me/).

This app generates arcade sounds from the 70s and 80s. 

Rev 2

![RetroVibratoWeb_P2 gif](retrovibratoweb_p2.gif)

![RetroVibrato_Drawer_panel png](RetroVibrato_Drawer_panel.png)

![RetroVibrato_Settings png](RetroVibrato_Settings.png)


# Projection creation
```sh
flutter create --platforms web .
```

# Notes
Some of the json files have what appear to be invalid values, for example, JettsonSaucer.json has negative envelope Attack and Decay but the range is from 0->1.

I believe this was from the Mutate() and Random generators. It has code that could potentially generate negative values, for example:
```go
Mutate is:
i.baseValues.attack += frnd(0.1) - 0.05

Random is:
o.baseValues.attack = cube(rndr(-1.0, 1.0))
```
One kind of fix would be to *abs(add 0.5)* to anything < 0.

The fix for Random would be to check what the range is and use that instead of hardcoded (-1,1)

# Menus
- Generators
- Wave Forms
- Volume slider
- Save
    - sfxr
    - wave
- Load
    - sfxr
- Sample Rate
    - 44 KHz (default)
    - 22 KHz
    - 11 KHz
    - 5.5 KHz
- Sample Size
    - 16 bits
    - 8 bits (default)
- About

# Tasks
- ☑ Settings sliders
- ☑ State management. Used Provider
- ☑ Load json and updating GUI
- ☑ Saving json and updating GUI
- ☑ Clicking a slider label resets it to Reset value
- ☑ Add Generator selector (top)
- ☑ Add Wave form selector (under top)
- ☑ Add volume slider (next)
- ☑ Add SampleSize 
- ☑ Saving wave file via download
- ☑ Porting generator algorithm from Ranger-Go-IGE
- ☑ Implement play button
- ☑ Add Help popup
- ☑ Complete Auto play (optiona, on by default)
- ☒ Implement 22KHz, 11KHz,5.5KHz sample rate options
- ☒ Implement 16 bit sample size option
- ☒ Add exception handling (optional)

- ☑
- ☒

# Audio
mime types:
- https://github.com/higuma/web-audio-recorder-js
- https://mimetype.io/audio/wav

https://pub.dev/packages/audiofileplayer
audiofileplayer 2.0.1


## Just Audio package
[Just Audio package](https://pub.dev/documentation/just_audio/latest/)

https://stackoverflow.com/questions/67078045/flutter-just-audio-package-how-play-audio-from-bytes

Streaming audio in Flutter with Just Audio (unfortunately it is behind medium's paywal)
- [Part 1](https://suragch.medium.com/playing-short-audio-clips-in-flutter-with-just-audio-3c80eb7eb6ea)
- [Part 2](https://suragch.medium.com/steaming-audio-in-flutter-with-just-audio-7435fcf672bf)

### Notes
```
  ByteBuffer buffer = Uint8List(8).buffer;
  ByteData bdata = ByteData.view(buffer);
  bdata.setFloat32(0, 3.04);
  int huh = bdata.getInt32(0);
```
MasterVolume = 1
