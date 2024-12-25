#!/bin/bash

# Get the uptime in minutes
uptime_minutes=$(awk '{print int($1/60)}' /proc/uptime)

# Check if uptime is over 30 minutes
if [ "$uptime_minutes" -gt 30 ]; then
    echo "The system has been up for more than 30 minutes."
#bash /tmp/opionemain.sh;

else
    echo "The system has been up for 30 minutes or less."
fi





