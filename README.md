## i3-audio-rotate
Rotate between audio devices in polybar with a click.

![Module preview](/images/switch.gif)

## Requeriments
[Pulseaudio](https://wiki.archlinux.org/title/PulseAudio) 

Pulseaudio is the default in some distros like Ubuntu 22.04, and popOS.<br>
You can check using [u\VisualArm9](https://www.reddit.com/r/linux4noobs/comments/n7tf6r/comment/gxem1bt/?utm_source=share&utm_medium=web2x&context=3) comment in Reddit.

Other easy way to check if the script will work can be, running ```pactl list short sinks```, and checking for sound card names. More in [Extra Tweaks](#extra-tweaks).

## Instalation
```
git clone https://github.com/Bushyon/i3-audio-rotate.git
mkdir ~/.config/polybar/scripts/
cp sink_change.sh ~/.config/polybar/scripts/sink_change.sh
cat module.ini >> ~./config/polybar/config.ini
```
You can change the device by left clicking in the module in your Polybar.

Remember to add **sink_device** to your bar modules!
![Module in Polybar config](/images/add_module.png)

## Extra Tweaks

### Ajusting the label
Note that **$active_device** is being compared to the sound cards in my PC, probabily yours will be different:

```
device(){
    active_device=$(pactl get-default-sink)
    
    if [[ $active_device == *"Focusrite"* ]]; then
        echo Headphone
    elif [[ $active_device == *"pci-0000_00_1f"* ]]; then 
        echo Speaker
    else 
        echo Not Configured
    fi
}
```
To correct it run ```pactl list short sinks``` and the output will be something like:
```
223	alsa_output.pci-0000_00_1f.3.analog-stereo	PipeWire	s32le 2ch 48000Hz	SUSPENDED
226	alsa_output.usb-Focusrite_Scarlett_Solo_USB_xxx-00.analog-stereo	PipeWire	s32le 2ch 48000Hz	SUSPENDED
```
In this case my soundcards are:

alsa_output.pci-0000_00_1f.3.analog-stereo - Speaker<br>
alsa_output.usb-Focusrite_Scarlett_Solo_USB_xxx-00.analog-stereo - Headphone

I just need to add one unique part of the string in the [sink_change.sh](/sink_change.sh) file, pci-0000_00_1f and Focusrite.

### HDMI sound sinks

Right now, i dont use sound over HDMI in myy setup, so I added an line to ignore sound cards like this. If this isan´t your case, you can change it by removing **grep -v "hdmi" |**  one line part of [sink_change.sh](/sink_change.sh). 

The result will be:
```
rotate_sound_cards() {
    active_sink=$(pactl get-default-sink)
    sinks=$(pactl list short sinks | awk '{print $2}')
```

## Testing features
Recently I found a good script to send one single application audio stream to a sink without changing the output for everything.<br>
This script is made by: [bannatech/pmenu](https://github.com/bannatech/pmenu/tree/master), but is used with dmenu. I managed to convert it to reflect my usecase with Rofi, but is in a test phase. <br>
If you want to test it, just copy pmenu_rofi to ~/.config/polybar/scripts and uncomment the line below in the sink_device module:
```
click-right = ~/.config/polybar/scripts/pmenu_rofi.sh
```
