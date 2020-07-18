# Deviations_1

These files relate to challenge #1 of Deviations, the CTF for GRCon 2020.

- ```Deviations_1.md```/```odt```: write-up about the challenge
- ```SARSAT_7.csv```: Satellite info for Sarsat-07, aka NOAA-15, in CSV format
- ```2016keps.txt```: AMSAT 2-line keplerian elements bulletin from that time in 2016
- ```range-rate.py```: Python+SkyField code to compute Doppler shift
- ```sample-output.txt```: Output from range-rate.py

## ```range-rate.py``` program
The Python+SkyField program ```range-rate.py``` computes the Doppler curve
between a specified satellite and a specified location at a specified
frequency. The satellite Keplerian elements are read in from a file of
2-line elements, ```2016keps.txt```. All other settings are hard-coded
in the Python file; change the file to compute a different configuration.
The specific satellite from the elements file is specified by number
as ```satellite_number```, and the frequency is ```frequency```. Locations
such as Crack in the Ground (```crack```) and Area 51 (```area51```) are
defined in the code by latitude, longitude, and elevation above sea level
in meters; you can add more locations as needed. The variable ```location```
is then set to one of these locations, and that location is used in the
computation. The variable ```pass1``` is a list of times at intervals of
exactly 1 second, defined by a start time and a range of seconds after the
start time. The program computes the Doppler shift at each of these times,
and outputs results as a decimal date in days and a decimal frequency offset
in Hertz, separated by a space. Output is suppressed when the satellite is
below the horizon for that location.

You'll probably need to
```sh
pip install skyfield
```
and you'll need to be running Python 3.something.
