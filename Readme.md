jdsp4rp5 (temp root) app: JamesDSP in temporary root mode for Retroid Pocket 5
===================================================================================

Download and install jdsp4rp5app.apk
open the app
Allow Jdsp4rp5 (temp root) to sent you notifications -> allow.

Tap on Enable JDSP

Tap on "Install bundled JamesDSP..."
	When asked:
	* confirm to "Open with package installer"
	* install unknown apps: -> allow from this source.
	* finally confirm JamesDSP installation
	
Open the newly installed application
	* Allow JamesDSP to send you notifications

Condigure JamesDSP for Retroid pocket 5 speakers:
	* Set limiter threshold to -0.10dB
	* Set limiter release to 500.00ms
	* Set Post gain to 15.00dB
	* Enable multimodal equalizer
	* Enable Arbitrary response equalizer
	* Click on the graph and tap "Edit as string"
	* Paste this magic string:
	  GraphicEQ: 480 0; 600 -5; 700 -15; 850 -10; 1200 -10; 
	  1670 -15; 2160 -18; 2800 -18; 3800 -28; 5000 -8; 7000 0;
	* If needed, turn on JamesDSP by tapping the "Power on"
	  icon in the center/lower part of the screen.
	  
You're done, now go back to the Jdsp4rp5 (temp root) app
and select if you want or not JamesDSP to start at every boot.
