# ((•)) Jdsp4Rp5 (temp root) app 
### *JamesDSP in temporary root mode for Retroid Pocket 5 and Retroid Pocket Flip 2*

**Retroid Mini** is not officially supported, please see [here](https://github.com/kokoko3k/jdsp4rp5.app/issues/4)

<br>

### The problem:
Retroid Pocket 5 speakers sounds really bad out of the box.
Flip 2 is a bit better, but there is still room for improvement.
Unfortunately, rootless equalizer solutions cannot be applied to low latency
applications like most of the emulators, so a root solution is needed,
but rooting the Retroid consoles voids their warranty, so we'll use temporary root permissions just for the task, and a reboot can optionally restore your console state.

### Benefit/what to expect:
* A dramatic improvement in sound quality from the speakers.
* A fairly linear frequency response from 400hz to 10khz.
obtained through profiling the sound via professional calibration 
microphone while the hands were "on" the console, That's the intended use.

### What NOT to expect:
* You won't hear anything lower than 400hz, nor did I bothered to
make it possible, since that would have lowered the volume
to absymal levels. RP5's little speakers are just not up to the task.

### Drawbacks:
* The audio output latency will increase by about 70ms.
* The output volume will be lower.
* CPU usage will be slightly higher (<1%).

-----------------------------
### **ELI5, OVER-DETAILED HOW TO:**
-----------------------------
![ ](https://github.com/kokoko3k/jdsp4rp5.app/blob/main/repo_images/shot1.jpg?raw=true)

* Download and install jdsp4rp5app.apk
from the release/assets page
* Open the app
* Allow Jdsp4rp5 (temp root) to sent you notifications -> allow.

* Tap on "Enable JDSP"

* Tap on "Install bundled JamesDSP..."

	When asked:
	* Confirm to "Open with package installer"
	* Install unknown apps: -> allow from this source.
	* Finally confirm JamesDSP installation
	

* Open the newly installed application
	* Allow JamesDSP to send you notifications

* Now let's configure JamesDSP for Retroid pocket 5 or Flip 2 speakers:
	* Set limiter threshold to -0.10dB
	* Set limiter release to 500.00ms
	* Set Post gain to 15.00dB
	* Enable Arbitrary response equalizer
	* Click on the graph and tap "Edit as string"
	* For Retroid Pocket 5, when using the official grip, it's a good idea to fill the hollow handles with something like foam or sponge pieces. This prevents the plastic from acting as a resonance chamber, ruining the sound.<br>
	* Retroid Pocket 5: paste this magic string (2025/07/31 improved, thanks tobakutiku!):<br>
	```
  	GraphicEQ: 480 0; 600 -5; 700 -16; 1000 -18; 1200 -10; 1670 -10; 2160 -18; 2800 -18; 3800 -28; 5000 -7; 7000 0;
	```
	* Flip 2: Paste one of the following magic strings:<br>
  	```
	GraphicEQ: 347 0; 450 -4.5; 500 -8 ; 600 -4.5; 1015 -17.5; 1500 -13; 2300 -8; 4000 -8.5; 6000 -13.5; 7000 -16.5; 8500 -22.5; 11000 -12; 12000 -4; 16000 0;
	```
   * Flip 2: but with more (and more) sparkling sound:
  	```
	GraphicEQ: 25 -1.5; 63 -0.75; 100 0.0; 347 -0.74; 450 -5.9425; 500 -9.6425; 600 -6.25; 1015 -19.55; 1500 -14.59; 2300 -8.97; 4000 -8.63; 6000 -13.37; 7000 -16.31; 8500 -22.22; 11000 -11.71; 12000 -3.79; 16000 -0.125;
	```
  	```
	GraphicEQ: 25 -3.00; 63 -1.50; 100 0.00; 347 -1.48; 450 -7.385; 500 -11.285; 600 -8.00; 1015 -21.60; 1500 -16.18; 2300 -9.95; 4000 -8.75; 6000 -13.25; 7000 -16.13; 8500 -21.94; 11000 -11.42; 12000 -3.59; 16000 -0.25;
	```
   * Pocket 5 + Flip 2 (optional): Since the speakers are very close, I think it is good to widening the stereo image.<br>
   You can do that by scrolling down the effects list and enable "Live programmable DSP", then immeddiately down, tap "Liveprog script", tap "stereo", and tap "stereowide", tap "additional script parameters" and set "Stereo width" to 2.00
* Tap the cog icon in the lower/left side of the screen
* Select Audio processing, enable "Legacy mode".
* If needed, turn on JamesDSP by tapping the "Power on" icon in the center/lower part of the screen.


   
## You're done! <br>
* Now go back to the Jdsp4rp5 (temp root) app select if you want or not JamesDSP to start at every boot. <br>
* Reboot to verify everything works correctly (give the app a few secs to setup everything).


### Credits/License:
* This package/app and the scripts made by kokoko3k are released under the 
The GNU General Public License v2.0.
* Provided libjamesdsp.so by James Fung 
* Provided JamesDSPManagerThePBone.apk by James Fung
* Thanks to ShadoV from JamesDSP [Community] Telegram channel
for insights and support over audio_effects.xml
* Thanks to Sayrune from RP5's discord channel
for support on audio_policy_configuration.xml
* Audio analysis done via: Room EQ Wizard https://www.roomeqwizard.com
<br>
<br>
For everyone concerned about the **audio latency**,
this is from a real gameplay session under GameNative:
<br>
https://github.com/user-attachments/assets/413deb5f-de58-48f8-9db6-bed677733530


