pulseaudio -k
pactl load-module module-remap-source source_name=VirtualMicro master=alsa_input.pci-0000_00_1f.3.analog-stereo source_properties=device.description=VirtualMicro
pactl load-module module-remap-source source_name=VirtualMicro master=alsa_input.usb-0b0e_Jabra_Link_370_3050751EEC16015200-00.mono-fallback
pactl load-module module-null-sink sink_name=mix sink_properties=device.description="Mix"
pactl load-module module-null-sink sink_name=fx sink_properties=device.description="FX"
pactl load-module module-loopback sink=mix source_output_properties=media.name="Micro"
pactl load-module module-loopback source=fx.monitor sink=mix source_output_properties=media.name="FXinput" 
pactl load-module module-loopback source=fx.monitor source_output_properties=media.name="FXoutput"
pactl load-module module-loopback source=VirtualMicro sink=fx source_output_properties=media.name="FromVirtualMicroToMix" 

