#where the script resides (passed as argument by the upper script)
	SDIR="$1"
	
#the mountpoint to the tmpfs tree used to mount the new soundfx lib dir.
	TMPFS="$SDIR/support/jdsp4rp5_tmpfs"

#where soundfx libs resides
	SOUNDFX_DIR=/vendor/lib/soundfx

### Cleanup

	umount /vendor/etc/audio/audio_policy_configuration.xml

    for m in $(mount |grep tmpfs | grep $(basename $TMPFS)| awk -F' on ' '{print $2}' | awk -F' type ' '{print $1}') ; do
      umount -l "$m"
    done

    for m in $(mount |grep tmpfs | grep "$SOUNDFX_DIR"| awk -F' on ' '{print $2}' | awk -F' type ' '{print $1}') ; do
      umount -l "$m"
    done
	
    umount /vendor/etc/audio_effects.xml

    umount /vendor/etc/acdbdata/MTP
    umount /vendor/etc/audio_policy_volumes.xml
    umount /vendor/etc/default_volume_tables.xml
    umount /vendor/etc/mixer_paths_qrd.xml

### /end Cleanup


#Override /vendor/etc/audio/audio_policy_configuration.xml
#This is needed to force the low latency path and enable JamesDSP effect processing
#on ull (ultra low latency?) clients too.
	mount -o bind $SDIR/support/conf_files/audio_policy_configuration.xml /vendor/etc/audio/audio_policy_configuration.xml
	chown root:root /vendor/etc/audio/audio_policy_configuration.xml
	chmod 0644      /vendor/etc/audio/audio_policy_configuration.xml
	chcon u:object_r:vendor_configs_file:s0 /vendor/etc/audio/audio_policy_configuration.xml	
	
	
#Override audio_effects.xml
#This registers JamesDSP library in the Android Audio effect chain
	mount -o bind $SDIR/support/conf_files/audio_effects-jdsp.xml /vendor/etc/audio_effects.xml
	chown root:root /vendor/etc/audio_effects.xml
	chmod 0644      /vendor/etc/audio_effects.xml
	chcon u:object_r:vendor_configs_file:s0 /vendor/etc/audio_effects.xml 

#setup a tmpfs mountpoint
	if [ ! -d "$TMPFS" ]; then
		echo "Creating mountpoint $TMPFS"
		mkdir "$TMPFS"
	fi
	mount -t tmpfs tmpfs $TMPFS

#copy  new effect libs and original soundfx the over it.
	VDIR="$SDIR/support/libs"
	cp $VDIR/libjamesdsp.so $TMPFS/
	cp -av /vendor/lib/soundfx/* $TMPFS/
	
#bind mount the cooked TMPFS over the system soundfx dir
	mount -o bind $TMPFS /vendor/lib/soundfx
	
#set permissions and SELinux context
	chown root:root /vendor/lib/soundfx/*
	chmod 0644      /vendor/lib/soundfx/*
	chcon u:object_r:vendor_configs_file:s0 /vendor/lib/soundfx/*

#override (or skip?) qcom acdbdata calibrations fixes missing bass
#on right speaker on low-latenncy path.
  mount -o bind /vendor/etc/acdbdata/QRD /vendor/etc/acdbdata/MTP

#The previous operation lowers the volume for unknown reasons and
#produces a lack in overall bass presence.
#Compensating by highering the default WSA_RX[0,1] Digital Volume
#seems to restore bass presence (mixer_paths_qrd.xml).
    mount -o bind $SDIR/support/conf_files/mixer_paths_qrd.xml /vendor/etc/mixer_paths_qrd.xml
    chown root:root /vendor/etc/mixer_paths_qrd.xml
    chmod 0644      /vendor/etc/mixer_paths_qrd.xml
    chcon u:object_r:vendor_configs_file:s0 /vendor/etc/mixer_paths_qrd.xml

#The previous operation leads to distortion pretty early, so we need to lower
#the volume curves.
  mount -o bind  $SDIR/support/conf_files/default_volume_tables.xml /vendor/etc/default_volume_tables.xml
  mount -o bind  $SDIR/support/conf_files/audio_policy_volumes.xml /vendor/etc/audio_policy_volumes.xml
  chown root:root /vendor/etc/default_volume_tables.xml
  chmod 0644      /vendor/etc/default_volume_tables.xml
  chcon u:object_r:vendor_configs_file:s0 /vendor/etc/default_volume_tables.xml
  chown root:root /vendor/etc/audio_policy_volumes.xml
  chmod 0644      /vendor/etc/audio_policy_volumes.xml
  chcon u:object_r:vendor_configs_file:s0 /vendor/etc/audio_policy_volumes.xml

#Finally, restart audio system
	killall -q audioserver
	killall -q mediaserver
	
#restart(?) jamesdsp
	#pm disable james.dsp
	#pm enable james.dsp

#It seems root is able to start hidden activities; do that to enable JamesDSP.
am start james.dsp/me.timschneeberger.rootlessjamesdsp.activity.EngineLauncherActivity

