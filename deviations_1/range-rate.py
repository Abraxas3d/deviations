# Compute Doppler shift on uplink OR downlink for a satellite pass
#
# Set the frequency, satellite number, and location below
#
# 2020-06-15 kb5mu

import numpy as np
from skyfield.api import load, Topos

frequency = 146e6
satellite_number = 25338

# Crack in the Ground, OR 43 20 01.30 N, 120 40 20.27W 1365m
crack = Topos(latitude_degrees = 43.3336944,
             longitude_degrees = -120.6722972,
             elevation_m = 1365)

# Area 51 37°14′0″N 115°48′30″W per Wikipedia
area51 = Topos(37.2333333, -115.8083333, elevation_m = 1362)

location = crack

# Load antique Keplerian elements and index them by name and number
# (note: SkyField is picky about TLE format. AMSAT files need to have
#  spaces added after each satellite name for the name to be accepted.)
sats = load.tle_file('2016keps.txt')
sats_by_name = {sat.name: sat for sat in sats}
sats_by_number = {sat.model.satnum: sat for sat in sats}
# sat = sats_by_name['NOAA-15']
sat = sats_by_number[satellite_number]

ts = load.timescale(builtin=True)

# Set up a vector of times that spans a pass, at intervals of 1 second.
# These values were computed separately, but it would be easy enough
# to do it on the fly.
# (can't call it just pass, that's a keyword)
pass1 = ts.utc(2016, 5, 12, 12, 35, range(0,12*60))

# dummy
# measure the distance between the ground and the satellites at each point
topocentric = (sat - location).at(pass1)

# convert to azimuth, elevation, and range
el, az, range = topocentric.altaz()

# compute simple range-rate as deltas of range
rrate = -np.diff(range.km)

# Output a table of the entire pass (trimmed at the horizon crossings)
# Column 1 = International Atomic Time as a Julian date
# Column 2 = satellite's elevation above horizon in degrees
# Column 3 = range to the satellite in kilometers
# Column 4 = 1st difference of range
#for t,e,d,r in zip(pass1.tai, el.degrees, range.km, rrate):
#	if e > 0:
#		print(f'{t} {e:.3f} {d:7.1f} {r}')

# Output a table of the entire pass (trimmed at horizon crossings)
# Column 1 = International Atomic Time as a Julian date (decimal days)
# Column 2 = Doppler shift at the specified frequency
for t,e,r in zip(pass1.tai, el.degrees, rrate):
	if e > 0:
		doppler = frequency * r / 299792.458	# speed of light in km/sec
		print(f'{t} {doppler}')

