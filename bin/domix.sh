#! /bin/bash
# Create a "mix" input on pulse audio for mixing a source like a microphone
# and an FX fake sink, that will mix into this source and also can be heard on output
# To use it, just start the script, it will create (among other thing) a Mix sink and a FX sink
# Select "Monitor of Mix" on your recording app (Google Meet, Slack, ...)
# To send some sound on the mix, application (e.g Spotify, Firefox tab with sample) should be routed to FX (via pavucontrol)
IDS=""
# Create mix sink
IDS="$IDS $( pactl load-module module-null-sink sink_name=mix sink_properties=device.description="Mix" )"
# Attach "Micro" to the mix sink. For now "Micro" source is selected automatically but can be selected
# on "Recording" tab of pavucontrol
IDS="$IDS $( pactl load-module module-loopback sink=mix source_output_properties=media.name="Micro" )"
# Create "FX" sink, attach it to mix sink and to the standard output
IDS="$IDS $( pactl load-module module-null-sink sink_name=fx sink_properties=device.description="FX" )"
IDS="$IDS $( pactl load-module module-loopback source=fx.monitor sink=mix source_output_properties=media.name="FXinput" )"
IDS="$IDS $( pactl load-module module-loopback source=fx.monitor source_output_properties=media.name="FXoutput" )"
# We list here all the ids to do the cleanup if you want to get rid of all sinks/loopback created
echo "To remove: "
for ID in ${IDS}; do
    echo "pactl unload-module ${ID}"
done

pactl load-module module-remap-source master=mix.monitor source_name=mix source_properties=device.description=SourceMix
pactl load-module module-remap-source master=fx.monitor source_name=mix source_properties=device.description=SourceFx

exit 0

microphone="alsa_input.usb-0b0e_Jabra_Link_370_3050751EEC16015200-00.mono-fallback"
speakers="alsa_output.pci-0000_00_1f.3.analog-stereo"

echo "Setting up echo cancellation"
pactl load-module module-echo-cancel use_master_format=1 aec_method=webrtc \
      aec_args="analog_gain_control=0\\ digital_gain_control=1\\ experimental_agc=1\\ noise_suppression=1\\ voice_detection=1\\ extended_filter=1" \
      source_master="$microphone" source_name=mic_ec source_properties=device.description=mic_ec \
        sink_master="$speakers"     sink_name=spk_ec   sink_properties=device.description=spk_ec

echo "Creating virtual output devices"
pactl load-module module-null-sink sink_name=vsink_fx     sink_properties=device.description=vsink_fx
pactl load-module module-null-sink sink_name=vsink_fx_mic sink_properties=device.description=vsink_fx_mic

echo "Creating loopbacks"
pactl load-module module-loopback latency_msec=30 adjust_time=3 source=mic_ec           sink=vsink_fx_mic
pactl load-module module-loopback latency_msec=30 adjust_time=3 source=vsink_fx.monitor sink=vsink_fx_mic
pactl load-module module-loopback latency_msec=30 adjust_time=3 source=vsink_fx.monitor sink=spk_ec

echo "Setting default devices"
pactl set-default-source vsink_fx_mic.monitor
pactl set-default-sink   spk_ec


exit 0
