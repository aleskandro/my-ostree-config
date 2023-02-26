#!/bin/bash

# This script monitors the pulseaudio output device and executes a remote call to a Yamaha RX-V475 amp APIs
# to switch its input source to be the one specified in the args
# Usage example: ./yamaha-controld.sh alsa_output.pci-0000_00_1b.0.iec958-stereo 192.168.0.250 AV1 -200
# The last argument is the volume to set the receiver to, it is optional with a default value of -200.
# The measure unit is dB, so -200 is -20.0 dB

set -Eeuo pipefail

YAMAHA_SINK=${1}
YAMAHA_HOST=${2}
YAMAHA_SOURCE=${3}

send() {
    curl -w '\n' -sL -X POST "http://${YAMAHA_HOST}/YamahaRemoteControl/ctrl" \
      -H 'Content-Type: application/xml' \
      --data-binary @- <<EOF
<?xml version="1.0" encoding="UTF-8"?>
  <YAMAHA_AV cmd="PUT">
    <Main_Zone>
      $(cat)
    </Main_Zone>
  </YAMAHA_AV>
EOF
}

power_on() {
    send <<EOF
  <Power_Control><Power>On</Power></Power_Control>
  <Input><Input_Sel>${YAMAHA_SOURCE}</Input_Sel></Input>
EOF
}

power_off() {
    send <<EOF
  <Power_Control><Power>Standby</Power></Power_Control>
EOF
}

output=$(pactl get-default-sink)
prev_output="${output}"
while read -r; do
    # Get the current output device
    output=$(pactl get-default-sink)
    # if the event is not a change of the output device, continue
    [ "${prev_output}" == "${output}"  ] && continue
    echo -n "[CHANGE] ${prev_output}  ---->  ${output}"
    # If the output device is the one running to the Yamaha AV-RXV475 amp,
    # let's switch the amp's source to be the one from the workstation
    if [ "$output" = "${YAMAHA_SINK}" ]; then
        echo ": setting the Yamaha RX-V475 to AV1 input."
        power_on
    elif [ "${prev_output}" == "${YAMAHA_SINK}" ]; then
        echo ": powering off the Yamaha RX-V475."
        power_off
    fi
    echo
    prev_output=${output}
done < <(pactl subscribe 2>/dev/null | grep --line-buffered -E "sink|server")
