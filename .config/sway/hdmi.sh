#!/bin/bash

# Check if the argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 [on|off]"
    exit 1
fi

# Determine the action
action=$1

# Get the name of the monitor
monitor_name=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused == true).name')

# Check if the monitor is already in the desired state
current_state=$(swaymsg -t get_outputs | jq -r ".[] | select(.name == \"$monitor_name\").active")
if [ "$action" == "on" ] && [ "$current_state" == "true" ]; then
    echo "Monitor is already on."
    exit 0
elif [ "$action" == "off" ] && [ "$current_state" == "false" ]; then
    echo "Monitor is already off."
    exit 0
fi

# Perform the action
if [ "$action" == "on" ]; then
    swaymsg output "$monitor_name" enable
    echo "Monitor turned on."
elif [ "$action" == "off" ]; then
    swaymsg output "$monitor_name" disable
    echo "Monitor turned off."
fi
