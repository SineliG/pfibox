#!/usr/bin/env python

import pifacedigitalio
import picamera
import time
import os
from fractions import Fraction
from nyanbar import NyanBar

camera = picamera.PiCamera(resolution=(2592, 1944))
pfd = pifacedigitalio.PiFaceDigital()

# Set camera conditions for capture
camera.framerate = 1
camera.iso = 100
camera.awb_mode = 'off'

# Create a directory 'images' if it doesn't exist, bypassing race condition
try:
    os.makedirs('images')
except OSError:
    if not os.path.isdir('images'):
        raise

# Number of hours to run the experiment
nHours = 18

# Sampling every x minutes
intervals = 5

nMins = nHours*60
timer = 0
leds = 1

# Initialize the leds with the first one only
pfd.leds[0].turn_on()
pfd.leds[0].set_high()

progress = NyanBar()

while timer <= nMins:
    # Update progress bar
    progress.update((timer/nMins)*100)
    # Light up the transilluminator
    pfd.relays[0].value = 1

    # Set camera values
    camera.awb_gains = 1,0.5
    camera.brightness = 55
    camera.saturation = 30
    camera.exposure_compensation = 25
    camera.contrast = 50
    camera.shutter_speed = 220000
    
    # Let camera stabilize
    time.sleep(10)

    # Take the gfp image
    camera.capture('images/%s.png' % timer,format='png',quality=100)
   
    # Wait a bit and shut down the transilluminator
    time.sleep(5)
    pfd.relays[0].value = 0

    # Light up an led every (expt/8) minutes
    if timer > ((nMins/8)*leds):
        pfd.leds[leds].turn_on()
        pfd.leds[leds].set_high()
        leds = leds + 1

    # Progress the timer by the number of minute intervals
    time.sleep((60*intervals)-20)
    timer = timer + intervals

progress.finish()





