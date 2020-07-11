#Deviations\_1#

Abraxas3d\
MustBeArt\
FirmWarez


**Deviations** is the name of the GNU Radio Conference 2020 (GRCon20)
Capture the Flag (CTF) competition.\
\
**Deviations\_1** is the first challenge of the CTF. We want to include
it in an upcoming issue of Microwave Journal. This tracking document is
a record of the construction of this challenge.\
\
*Please do not share outside distribution since it would reveal how to
solve it and how the CTF is constructed. If you do not want to know
these details then do not read any further. We want to use this
challenge to advertise the conference and the CTF. We want to include
people that want to help create the challenge. We do not want to spoil
it for people that would otherwise compete.*\
\
Ok what’s the story on challenge 1?\
\
SARSAT (the Search and Rescue satellite system) was activated in May
2016 by a hiker using an unregistered personal locator beacon.\
\
Read more about SARSAT here:\
<https://en.wikipedia.org/wiki/International_Cospas-Sarsat_Programme>\
\
What SARSATs were up in May 2016?

Pick one, look at the tracks, figure out where and when the hiker was
lost, and then create Doppler curves for that satellite.\
\
The participant gets the waveform recording of the beacon signal which
are fundamentally Doppler radar images.

The participant extracts the Doppler information from the waveform. They
have to account for the Doppler from their ground station (which they
know) to the satellite, plus the Doppler from the satellite to the lost
hiker (this reveals the potential locations).\

They will also need the orbit model.\
\
They need to find the ground station location that the curves were
recorded from. That is the mission of search and rescue and why these
satellites orbit the Earth.\
\
They will know where they are, because perhaps they are Search and
Rescue, or they are a station intercepting Search and Rescue! Either way
works.

They need to know the downlink frequency.\
\
The hiker recovered by the search and rescue mission is none other than
D. B. Cooper. That is why the active investigation ended 8 July 2016.
Because he was picked up by the FBI in May of 2016. How did the FBI know
that this unregistered personal locator beacon was DB Cooper? Well they
didn’t, at first. But, an unregistered beacon is rare. It was a
serendipitous moment. Maybe the agent was tipped off by someone that
will be encountered later in the CTF. Someone that has been trying to
stop D.B. Cooper from revealing some incredibly important information.\
\
But, in May 2016, an FBI agent was simply along for the ride to the
search and rescue mission. The agent recognized the elderly hiker for
who he really was. D.B. Cooper! Holy crap! So D.B. was taken into
custody without incident.\
\
By July 2016, D.B. Cooper had been recruited by the FBI for several
reasons. First, because the FBI wanted to know how he hijacked the
plane, what he did with the money, and how he had evaded identification,
detection, and capture for so long.\
\
But also because D.B. Cooper was captured with a USB drive in his
pocket, from an SDR recording made near the Christmas Valley Air Force
Station, which is very near the Crack in the Ground, where D.B. Cooper
ended up on a dark night in mid-May, and got injured, and had to call
for help.\
\
The contents of that SDR recording are extremely sensitive. D.B. Cooper
does not know what is going on in Christmas Valley, but the CTF
participants slowly realize that the reason Mr. Cooper was deliberately
wrecked into Crack in the Ground, Oregon, was because someone was
interfering with his GPS signal as he returned from spying on Christmas
Valley Air Force Station (allegedly closed).\
\
Someone didn’t want him to get back to the Christmas Valley Sand Dune
camping grounds, where he was enjoying his well-earned vacation cover
story.\
\
The FBI had no idea he was in Oregon, let alone alive. No other
government agency admits to attempting to stop D.B. Cooper from
exfiltrating the data he collected on that USB drive.\
\
So, what is going on in Christmas Valley? Who was trying to stop D.B.
Cooper?\
\
That’s what the participants will uncover in this year’s GRCon20 CTF.\
\
For Deviations\_1, where we figure out the location of D.B. Cooper’s
personal emergency locator beacon, we need to produce an IQ .wav file of
the locator beacon. The locator beacon was activated and transmitted
from Crack in the Ground (the location the participants need to find for
Deviations\_1) up to a linear transponder. That transponder transmitted
the signal back down to a known location ground station. That ground
station is known to the participants, because that is their ground
station in the challenge. They know the frequency, location of their
ground station, time and date. They have to figure out which satellite
it came from, and correctly work out from the doppler curve the
potential location of the emergency beacon. We have to provide enough
information to get this location. The location is the flag, but there
needs to be an “easy to use” mechanism for this.\
\
SARSAT NOAA 15 is sun synchronous high LEO. Consistent optical view,
same lighting every time.\
\
Here’s recent KEPs:\
\
SARSAT 7 (NOAA 15)

1 25338U 98030A 20157.85653975 .00000079 00000-0 51767-4 0 9990

2 25338 98.7173 182.9664 0009298 299.7563 60.2692 14.25969989147327

We downloaded “Satellite Orbit Computation” from MATLAB to create the
files required for this Deviation.

Charles Rino (2020). Satellite Orbit Computation

https://www.mathworks.com/matlabcentral/fileexchange/28888-satellite-orbit-computation

MATLAB Central File Exchange.

“A modified version of the SGP4 code used for standard satellite orbit
computation using two-line elements (TLE). The modified code outputs
satellite positions and velocity in ECF coordinates and universal time
from EPOCH. Utilities are provided to calculate point-to-point angle,
range rates, TCS positions, constant altitude intercepts and velocities.
Outputs are collected in a structure and retained in a \*.mat file for
subsequent display and Beacon satellite data analysis applications.
Documentation and examples are provided. Code uses GPS\_CoordinateXform
and IGRF utilities available from MATLAB Central.”

We got OrbitCode working in MATLAB.\
\
We found historical Keplerian elements for NOAA 15.

12 May 2016\
\
*1 25338U 98030A 16133.50146488 .00000072 00000-0 49390-4 09999*

*2 25338 98.7831 137.5795 0009488 292.2377 67.7796 14.25723709935905

This is the sort of thing that the participants will need to find on
their own. It’s out there. They can get them.\
\
We attempted to load them into OrbitCode, but OrbitCode uses .mat files
to get the TLEs. The text TLE file is just there for reference.\
\
There’s no documentation for the creation of the .mat files. The
variables can be seen used in the source code, but this is quite a bit
of reversing and understanding how MATLAB works.\
\
It ran with the original demo code .mat files and generated plots, and
produces the information we need, so we figured this would be the right
path.\
\
There are two .mat files. One is for the station and the other contains
the TLEs. It looks like the author depended on alphabetical order to
pick up the correct one in the correct order! Maybe we can fix this
later.\
\
So, we made a parallel Demo Data directory called DeviationDemo and
copied over the Demo files.\
\
The .TLE file, which is human readable, unlike the .mat files, was
updated to hold the May 2016 TLEs for NOAA 15. This is just for
reference and documentation.\
\
Next we tried to change station location to somewhere in the pacific
northwest by loading the .mat file into a dedicated MATLAB script,
looking for variable names, and then updating those variables directly,
and saving back out into a new .mat file.\
\
DB Cooper was hiking the Christmas Valley Sand Dunes near the Christmas
Valley Air Force Station, with the allegedly closed over-the-horizon
radar station.\
\
OTHR will be one of the later CTF challenges.\
\
<https://en.wikipedia.org/wiki/Christmas_Valley_Air_Force_Station>

D.B. Cooper was there to spy on the ongoing operation.



![image](https://user-images.githubusercontent.com/6608613/87234292-5d802500-c384-11ea-8581-bc013d4d8c8a.png)




\
Here is a photo D.B. took.\
\
So what is really going on at Christmas Valley?\

Fort Rock, which is nearby, has archaeological artifacts that are up to
13,000 years old.\
\
Some of them are radio related.\
\
There is at least one artificial satellite that the government is
keeping secret, that appears to have been put in orbit by the people
that lived in Fort Rock Cave. This is close by Christmas Valley.\
\
<https://en.wikipedia.org/wiki/Fort_Rock_Cave>\
\
D.B. Cooper unknowingly recorded a pass of this ancient artificial
satellite while the Air Force was doing an ongoing experiment with it.
The Code Name of this investigation into the ancient satellite by the
Air Force is “Sagebrush Luther”.\
\
Sagebrush Luther is studying a satellite that has been stable over
13,000 years. It has what appears to be cloaking technology. The
satellite was initially revealed during post-WWII U.S. nuclear testing
and the U.S. Air Force has been slowly figuring out how to use, adapt,
and duplicate this technology ever since. Christmas Valley Air Force
Station is where Sagebrush Luther experiments are carried out.\
\
OK so where was DB Cooper when he got lost?\
\
He accidentally ended up falling into Crack in the Ground because there
was deliberate interference with his GPS.

![image](https://user-images.githubusercontent.com/6608613/87234307-7a1c5d00-c384-11ea-94a2-5dce86091471.png)



So we found some coordinates from Crack in the Ground (above).

Attempting to edit the .mat file was a real pain in the ass. Entire
odyssey deferred to some future cocktail party.

43.3299631,-120.6790451 (from google earth pro)

1364 meters (from google earth pro)

lct.station.rx\_latitude = 43.3300

lct.station.rx\_longitude = -120.6790

lct.station.rx\_altitude = 1364

OK so what date are these historic TLEs that we obtained good for? The
2016 ones?\
Let’s figure that out.

They are valid for May 12th noon UTC or later

Let’s pick a date for D.B. to fall into the Crack as late in the evening
on May 13^th^ in Pacific time. This is May 14th in UTC.

This means it is day 134 in a leap year. This will be useful later! 2016
was a leap year.

Why? Because May 13th 2016 is a Friday.

So, he falls into the Crack in the Ground on Friday the 13th May 2016,
Pacific time, like around 10pm.

0500 UTC 14 May 2016

lct.start\_daynumber = 134

lct.start\_year = 2016

lct.start\_month = 5

lct.start\_day = 14

lct.start\_hour = 5

lct.start\_minute = 0

lct.start\_second = 0

OK all this worked but we got (oddly) passes on the 19th of May.\
\
But we also got this:\
\
\
PASS\# 1 START: 5 19 12 59.00 END: 5 19 13 13.00

PASS\# 2 START: 5 19 14 39.00 END: 5 19 14 54.00

PASS\# 3 START: 5 19 16 20.00 END: 5 19 16 30.00

PASS\# 4 START: 5 19 22 46.00 END: 5 19 22 53.00

Computing B field at 300.00 km intercept

Error using warning

Unknown setting or incorrect message identifier ' This version of IGRF
intended for use to only to 2015 \\n'.

Error in igrf11syn (line 111)

warning('on',' This version of IGRF intended for use to only to 2015
\\n')

Error in satGEOM (line 115)

xyzt(:,n)=igrf11syn(fyear(n),alt\_km,satp\_llh(1,n)/dtr,satp\_llh(2,n)/dtr);

Error in GenerateSatelliteGeometry\_DEMO\_Linux\_Filenames (line 141)

satGEOM\_struct=satGEOM(satrec,Eyear,tsince\_min,origin\_llh,h\_intercept,plotTitle);\
\
\
LOL! 2015! I downloaded this library last week. It’s 2020.\
\
But no matter, because we are getting useful passes out of this. We’re
going to have to address the IGRF problem but let’s confirm what we’ve
got so far, first.

![image](https://user-images.githubusercontent.com/6608613/87234305-74bf1280-c384-11ea-8cb7-fb83c271a206.png)

\

Next we cross-checked with InstantTrack.\
\
In the console, and in the above data, we have a problem. Why are our
passes on 19 May? We asked for 13/14 May.\
\
Looking at the script, the tsince\_offset was set to 10,000, which was 7
days, so we set it to 0 as a test, and then set the number of passes to
be higher. Well guess what? That worked.\
\
This is the result:

![image](https://user-images.githubusercontent.com/6608613/87234309-7dafe400-c384-11ea-92a0-eadc4c9dee3c.png)

\
\
\
\
We now have two programs (MATLAB and InstantTrack) producing useful
time/date passes for NOAA 15.\
\
We need for the rest of it to work. We need the link from the satellite
to the receiving ground station. We have to calculate the range rate
(time derivative of the range) for both links in order to construct
Doppler curves for the .wave files.\
\
But, we’re well on the way and will pick up tomorrow with a goal of
being done by Monday.\
\
More soon!


