In order to create the 406 MHz digital beacons, MATLAB and GNU Radio were used. 

MATLAB was used to create the packet contents as close as reasonable according to https://tcmayak.ru/images/docs/CS-T001-JUN-27-2018.pdf

These packet contents were inserted as vectors in GNU Radio flowgraphs.

There is one flowgraph per beacon.

wav-file-viewer.grc demodulates and decodes the .wav files created by the beacons. Turn repeat file on. 

longer-pass is the output of range-rate.py. It's the times and doppler for the uplink 406 MHz beacons transmitted from Crack in the Ground for four passes on 12 May 2016. 

BCH_Generation.m is a MATLAB script used to create the fields of the 406MHz beacon packets. 
