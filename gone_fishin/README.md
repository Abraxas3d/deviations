# _Gone Fishin'_ Challenge Construction Debris

These are the leftovers from construction of the _Gone Fishin'_ challenge for the GNU Radio Conference 2020 CTF. The file descriptions below serve as a narrative of both the challenge construction and the expected challenge solution.

## gf-flag-convert.ipynb

This is a Jupyter notebook (for Python 3, run with Python 3.8.5) that (among other experiments) is used to generate the binary flag file. We start with the plain text flag, base64 encode it for a little obscurity, and then set the most significant bit of every other byte so that the encoded string won't show up by just running _strings_ against the captured data. Note that you may need to skip some blocks; this was checked in when it worked, with no cleanup.

You might need to
```
pip3 install bitstring
```

## 9600baud-test.grc

This is a GNU Radio Companion (3.8.2 on Linux) flowgraph that records off the air at 2,000,000 samples/second centered at 439 MHz, using a HackRF One SDR. While making the recording, it is also filtering out the channel of interest at 439.05 MHz, demodulating it, parsing it as AX.25, displaying the results in hex, and outputting a KISS-format file. This is just for realtime verification that the desired signal was captured correctly.

This flowgraph uses blocks from [gr-satellites](https://github.com/daniestevez/gr-satellites/), and was tested with gr-satellites version v3.3.0.

A Kenwood TS-2000X transceiver was configured to use the internal TNC to send packet at 9600 baud on 439.05 MHz. Then the internal TNC was configured and put into converse mode, ready to send an _unprotocol_ packet.

```
cmd: UNPROTO CTF
cmd: MYCALL GRCON
cmd: TXDELAY 5
cmd: HBAUD 9600
cmd: CONVERSE
```
... and the flag was sent with a serial terminal emulator connected to the TS-2000X's serial port. I used [Serial 2](https://www.decisivetactics.com/products/serial/) and chose File->Send File..., using the Binary (Raw) transfer protocol. I had to hit Enter after sending the file to start the transmission, because I didn't plan ahead and put a newline at the end of the flag file.

The captured raw samples file is renamed to gone-fishin.bin and given to CTF players.

## 9600baud-recv.grc

This is a GNU Radio Companion (3.8.2 on Linux) flowgraph that takes the binary file as input, filters out the channel of interest, demodulates it, parses it as AX.25, displays the results in hex, and writes the results to a KISS-format file. This is more or less what the players are expected to have to do to recover the flag.

This flowgraph uses blocks from [gr-satellites](https://github.com/daniestevez/gr-satellites/), and was tested with gr-satellites version v3.3.0.

## gone-fishin.bin

This is the raw samples capture file created as 9600baud-test.bin by the flowgraph 9600baud-test.grc. This file is given to CTF players with little or no explanation.

Players are expected to bring this file into GNU Radio Companion (or any other capable signal processing program), search for and find the single packet transmission in the frequency spectrum, identify its modulation type, and arrange to demodulate it. The easy way (though perhaps not an immediately obvious way) to do that is to use blocks from the gr-satellites out-of-tree module. They will then be faced with the task of interpreting the demodulated bits. They are expected to guess that it is amateur packet radio, AX.25, which will be an easy guess to make if they are using gr-satellites. That module contains an AX.25 parser block, and if they look at documentation for it they will also learn about outputting the data to a KISS-format file. It's not a mandatory step, but it makes things easy-ish and I will assume they output a KISS file. Whether they output a KISS file or just raw bytes, they might hope that the flag is in there, so maybe they will look with strings.
```
$ strings g3ruh_recv.kiss 
@@@`
```

That doesn't work! (That's why we set the most significant bit in every other byte.) They then need a way to look at a KISS file, so ...

## kiss2asc.c

This is a modified version of [KISS2ASC](https://www.mustbeart.com/software/kiss2asc.html), a program that converts a KISS-formatted file of AX.25 frames into a readable form. It was modified to accept the timestamp frames that the KISS File Sink from gr-satellites inserts into the data stream. (Badly; instead of looking for the KISS frame command code 0x09, it simply assumes that any KISS frame with an 8-byte payload is a timestamp. If you run this against noisy data you'll eventually see some outrageously implausible timestamp values.)

If they run this against the captured KISS file, they will see the timestamp and the packet header, and some gibberish. Like this:
```
$ ./kiss2asc g3ruh_recv.kiss 
Timestamp: 2020-09-06 05:06:56.650
fm GRCON to CTF ctl UI pid F0
R.x.Z.t.Y.p.Y.Q.c.V.d.M.c.V.b.B.d.B.Y.J.c.B.I.B.Z.J.C.=.

```

They will see the pattern that every other character is a period, representing some unprintable character. At this point they are expected to look at the data field in hex.

```
$ od -x g3ruh_recv.kiss 
0000000 09c0 0000 7401 cf61 0a68 c0c0 8600 8ca8
0000020 4040 6040 a48e 9e86 409c 03e1 52f0 78ed
0000040 5ae8 74b3 59c9 70d8 59f4 51d8 63e7 56b3
0000060 64f0 4dc8 63e7 56b2 62ec 42e9 64e8 42c3
0000100 59d4 4ab3 63f0 42c8 49fa 42c6 5af0 4ad8
0000120 43b9 3de7 0dbd 00c0
```

Here they are expected to see the pattern that every other byte in the data field has its most significant bit set. It's expected that they will try stripping off that bit. So ...

## kiss2ascx7.c

This is the above program, further modified to strip off the most significant bit of every byte in the data field.

```
$ ./kiss2ascx7 g3ruh_recv.kiss 
Timestamp: 2020-09-06 05:06:56.650
fm GRCON to CTF ctl UI pid F0
RmxhZ3tIYXptYXQgc3VpdHMgc2VlbiBhdCBTY3JpcHBzIFBpZXJ9Cg==
```

Now, the '==' at the end is a clue that may catch the player's attention. Together with the fact that every character in the string is now printable, it suggests that the string might be a base64 encoding. If they run ```base64 -d``` against just the data field of the previous output, 

```
$ echo 'RmxhZ3tIYXptYXQgc3VpdHMgc2VlbiBhdCBTY3JpcHBzIFBpZXJ9Cg==' | base64 -d
Flag{Hazmat suits seen at Scripps Pier}
```

They win!

# g3ruh_recv.kiss

This is the output of the receive flowgraph, in KISS format.

# Text from challenge intro - solving Timey Wimey is required to reach this challenge

We had all been uncomfortable with the messages from under the ice. It just wasn't believable that our hiker or someone associated with him would be able to deploy this many pranks, this widely, while laid up in the hospital. 

Increasing reports of GPS intereference were making the news. The levels weren't yet above the old selective availability threshold, so all official public opinions were that things were performing normally. 

However, this was far from the case. 

A large amount of our staff was now supporting a multi-agency effort into what was going on with GPS. The amount of devices, equipment, and services depending on GPS was enormous. 

I took over anything that the automated scripts thought was useful chatter. 

And on Thursday morning, I got an unusual file. I started on that one first. 
