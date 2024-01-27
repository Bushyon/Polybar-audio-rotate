#!/bin/bash

# Rotates between sink devices (sound output devices).
rotate_sound_cards() {
    active_sink=$(pactl get-default-sink)
    sinks=$(pactl list short sinks | awk '{print $2}')

    if [[ -z $active_sink || -z $sinks ]]; then
        echo "Unable to retrieve sound cards or HDMI sinks"
        exit 1
    fi

    # Set numeric IDs for each sink
    declare -A sink_ids
    index=0
    for sink in $sinks; do
        sink_ids["$sink"]=$index
        ((index++))
    done

    # Get ID of the active sink
    active_sink_id=${sink_ids["$active_sink"]}

    # Calculate the next ID, wrapping around if necessary
    next_sink_id=$(( (active_sink_id + 1) % index ))

    # Get the sink name with the next ID
    next_sink=""
    for sink in "${!sink_ids[@]}"; do
        if [[ ${sink_ids["$sink"]} -eq $next_sink_id ]]; then
            next_sink="$sink"
            break
        fi
    done

    # Set the next sink as the default
    pactl set-default-sink "$next_sink"

    echo "Rotated sound card: $active_sink to $next_sink"
}

# This is a customized part, change the strings as you need. 
device(){
    active_device=$(pactl get-default-sink)
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)

    if [[ $active_device == *"Focusrite"* ]]; then
        echo Headphone $volume%
    elif [[ $active_device == *"pci"* ]]; then 
        echo Speaker $volume%
    else 
        echo Not Configured
    fi
}

if [ $1 = "--change" ]; then
    rotate_sound_cards
elif [ $1 = "--device" ]; then
    device
fi

