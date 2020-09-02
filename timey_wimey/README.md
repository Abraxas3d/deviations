# Timey-Wimey Challenge Construction Debris

These are the leftovers from construction of the Timey-Wimey challenge for the GNU Radio Conference 2020 CTF.

## WWV3.wav

This is an 192000 sample/second IQ recording taken from the air using a Flexradio 6600M and a 43-foot vertical in San Diego. The radio was tuned about 50 kHz above the 5 MHz carrier of WWV, so that the WWV signal would be off center. The DAXIQ1 channel from the Flex was recorded by Audacity, then the file exported in WAV format. The recording was timed to capture just under a minute of the channel, excluding only the seconds when the voice announcement provided the time. This was the third attempted capture.

Without the 50 kHz offset, the captured WAV file could be played in an ordinary audio player, and the WWV signal decoded by ear with no signal processing!

Within the captured passband were other strong signals from shortwave broadcasters. The strongest station happened to be playing a cover version of the Dr. Who theme, which serendipitously provided the theme for this challenge. This music signal dominates the result if you simply run the WAV file through an AM demodulator, but the WWV signal can also be heard.

## wwv-convert.grc

This is a simple GNU Radio Companion (3.8.2 on Linux) flowgraph that filters the WWV3.wav capture with parameters chosen to attenuate the signal from WWV. After filtering, the WWV signal is detectable but not strong enough to decode by ear after a simple AM demodulator. The player needs to locate the signal (at the low edge of the passband) and add some filtering before the demodulator.

The resulting file is named mangled32.wav, after several iterations of work.

## timeywimey.wav

This is the file that was provided to CTF players. It is identical to mangled32.wav, just renamed for aesthetic reasons.

## WWV_Player3.grc

This is a GNU Radio Companion (3.8.2 on Linux) flowgraph that recovers the time code modulation from the mangled32.wav file, as the player is expected to do. The audio output in subtone.wav can be decoded by ear or by plotting the signal against time.

The last few blocks of this flowgraph are an attempt to reduce subtone.wav to a digital signal. While this would work on a perfect signal, it is too simple to work on this capture due to fading. The player is free to do something smarter, but will probably find it more convenient to decode subtone.wav manually.

## WWVsubtone32.wav

This is the subtone.wav output of WWV_Player3.grc run against the final mangled32.wav file.

## WWVsubtone32-image.png

This is a screen capture of the waveform in WWVsubtone32.wav as displayed by Audacity.

## solution.jpg

This is a scan of a manual solution of the challenge. The screen capture was printed out and marked up in pencil to identify the individual bits of the time code, then converted to integer values, which together form the time of the WWV transmission.
