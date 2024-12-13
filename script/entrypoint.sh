#!/bin/bash
set -e

source "/opt/ros/$ROS_DISTRO/setup.bash"
if [ -f "/root/robot_ws/install/setup.bash" ]; then
    source "/root/robot_ws/install/setup.bash"
fi

exec "$@"
