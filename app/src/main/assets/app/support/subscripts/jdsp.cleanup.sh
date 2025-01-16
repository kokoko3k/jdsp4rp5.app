#where the script resides (passed as argument by the upper script)
	SDIR="$1"
#the mountpoint to the tmpfs tree
	TMPFS="$SDIR/support/jdsp4rp5_tmpfs"
#where soundfx libs reside
	SOUNDFX_DIR=/vendor/lib/soundfx

#cleanup
	umount /vendor/etc/audio/audio_policy_configuration.xml

	for m in $(mount |grep tmpfs | grep $(basename $TMPFS)| awk -F' on ' '{print $2}' | awk -F' type ' '{print $1}') ; do
		umount -l "$m"
	done

	for m in $(mount |grep tmpfs | grep "$SOUNDFX_DIR"| awk -F' on ' '{print $2}' | awk -F' type ' '{print $1}') ; do
		umount -l "$m"
	done
	
	umount /vendor/etc/audio_effects.xml
	

#restart audio system
	killall -q audioserver
	killall -q mediaserver
	
#restart(?) jamesdsp
	pm disable james.dsp
	pm enable james.dsp