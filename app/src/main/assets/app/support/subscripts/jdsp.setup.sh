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

#install /vendor/etc/audio/audio_policy_configuration.xml
	mount -o bind $SDIR/support/conf_files/audio_policy_configuration.xml /vendor/etc/audio/audio_policy_configuration.xml
	chown root:root /vendor/etc/audio/audio_policy_configuration.xml
	chmod 0644      /vendor/etc/audio/audio_policy_configuration.xml
	chcon u:object_r:vendor_configs_file:s0 /vendor/etc/audio/audio_policy_configuration.xml	
	
	
#install audio_effects.xml
	mount -o bind $SDIR/support/conf_files/audio_effects-jdsp.xml /vendor/etc/audio_effects.xml
	chown root:root /vendor/etc/audio_effects.xml
	chmod 0644      /vendor/etc/audio_effects.xml
	chcon u:object_r:vendor_configs_file:s0 /vendor/etc/audio_effects.xml 

#setup a tmpfs mount
	if [ ! -d "$TMPFS" ]; then
		echo "Creating mountpoint $TMPFS"
		mkdir "$TMPFS"
	fi
	mount -t tmpfs tmpfs $TMPFS

#copy  new effect libs and original soundfx the over it.
#(libv4a_fx.so has been elf-patched to search for libstdc++ in its dir)
	VDIR="$SDIR/support/libs"
	cp $VDIR/libjamesdsp.so $TMPFS/
	cp -av /vendor/lib/soundfx/* $TMPFS/
	
#bind mount the cooked TMPFS over the system soundfx dir
	mount -o bind $TMPFS /vendor/lib/soundfx
	
#set permissions and SELinux context
	chown root:root /vendor/lib/soundfx/*
	chmod 0644      /vendor/lib/soundfx/*
	chcon u:object_r:vendor_configs_file:s0 /vendor/lib/soundfx/*

#fix for right-side speaker lacking bass sound
  mount -o bind /vendor/etc/acdbdata/QRD /vendor/etc/acdbdata/MTP


#restart audio system
	killall -q audioserver
	killall -q mediaserver
	
#restart(?) jamesdsp
	#pm disable james.dsp
	#pm enable james.dsp

	am start james.dsp/me.timschneeberger.rootlessjamesdsp.activity.EngineLauncherActivity

