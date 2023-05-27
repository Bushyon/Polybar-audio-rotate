## i3-audio-rotate
Rotate between audio devices in Polybar with a click.

![Module preview](/images/switch.gif)

## Requirements
[PulseAudio](https://wiki.archlinux.org/title/PulseAudio)

PulseAudio is the default in some distros like Ubuntu 22.04 and Pop!_OS.<br>
You can check by using the [u\VisualArm9](https://www.reddit.com/r/linux4noobs/comments/n7tf6r/comment/gxem1bt/?utm_source=share&utm_medium=web2x&context=3) comment on Reddit.

Another easy way to check if the script will work is by running ```pactl list short sinks``` and checking for sound card names. More information in [Extra Tweaks](#extra-tweaks).

## Installation
```
git clone https://github.com/Bushyon/i3-audio-rotate.git
mkdir ~/.config/polybar/scripts/
cp sink_change.sh ~/.config/polybar/scripts/sink_change.sh
cat module.ini >> ~/.config/polybar/config.ini
```
You can change the device by left-clicking on the module in your Polybar.

Remember to add **sink_device** to your bar modules!

![Module in Polybar config](/images/add_module.png)

## Extra Tweaks

### Adjusting the label
Note that **$active_device** is being compared to the sound cards on my PC, which will likely be different for yours:

```bash
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
To correct it, run ```pactl list short sinks```, and the output will be something like:
```
223	alsa_output.pci-0000_00_1f.3.analog-stereo	PipeWire	s32le 2ch 48000Hz	SUSPENDED
226	alsa_output.usb-Focusrite_Scarlett_Solo_USB_xxx-00.analog-stereo	PipeWire	s32le 2ch 48000Hz	SUSPENDED
```
In this case, my sound cards are:

alsa_output.pci-0000_00_1f.3.analog-stereo - Speaker<br>
alsa_output.usb-Focusrite_Scarlett_Solo_USB_xxx-00.analog-stereo - Headphone

You just need to add a unique part of the string in the [sink_change.sh](/sink_change.sh) file, such as `pci-0000_00_1f` and `Focusrite`.

### HDMI sound sinks

Currently, I don't use sound over HDMI in my setup, so I added a line to ignore sound cards like this. If this isn't the case for you, you can change it by removing **grep -v "hdmi" |**, which is a one-line part of [sink_change.sh](/sink_change.sh).

The result will be:
```bash
rotate_sound_cards() {
    active_sink=$(pactl get-default-sink)
    sinks=$(pactl list short sinks | awk '{print $2}')
```

## Testing features

Recently, I came across a useful script that allows me to send the audio stream of a specific application to a particular audio sink without affecting the overall audio output.<br>
This script was originally created by [bannatech/pmenu](https://github.com/bannatech/pmenu/tree/master) for use with dmenu. However, I managed to adapt it to suit my needs with Rofi, although it is currently in a testing phase.<br>
If you'd like to try it out, simply copy the file [pmenu_rofi](/pmenu_rofi.sh) to the `~/.config/polybar/scripts` directory and uncomment the following line in the [sink_change.sh](/sink_change.sh) module:
```
click-right = ~/.config/polybar/scripts/pmenu_rofi.sh
```
