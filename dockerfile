ARG ROS2_DISTRO=jazzy

FROM ros:$ROS2_DISTRO-perception
ARG ROS2_DISTRO

ENV ROS2_DISTRO=$ROS2_DISTRO

# Install library for Orbbec sdk 
RUN apt-get update
RUN apt-get install libgflags-dev nlohmann-json3-dev  \
    ros-${ROS_DISTRO}-image-transport ros-${ROS_DISTRO}-image-publisher ros-${ROS_DISTRO}-camera-info-manager \
    ros-${ROS_DISTRO}-diagnostic-updater ros-${ROS_DISTRO}-diagnostic-msgs ros-${ROS_DISTRO}-statistics-msgs \
    ros-${ROS_DISTRO}-backward-ros libdw-dev \
    ros-${ROS2_DISTRO}-rosbridge-suite ros-${ROS2_DISTRO}-navigation2 ros-${ROS2_DISTRO}-nav2-bringup \
    ros-${ROS2_DISTRO}-slam-toolbox -y

# Setup build tools and libraries
RUN apt-get install python3-colcon-common-extensions -y
RUN apt-get install libserial-dev -y

# Setup workspace
RUN mkdir -p /root/robot_ws/src
WORKDIR /root/robot_ws/src

# Clone Web Video Server
RUN git clone -b ros2 https://github.com/RobotWebTools/web_video_server.git
# Clone Battery Level Broadcaster
RUN git clone https://github.com/netizen-robotics/battery_level_broadcaster
# Clone RPLidar
RUN git clone -b ros2 https://github.com/Slamtec/rplidar_ros.git
# Clone Orbbec ROS2 SDK
RUN git clone https://github.com/orbbec/OrbbecSDK_ROS2.git
# Clone MC2408 Motor Controller
RUN git clone https://github.com/netizen-robotics/mc2048-controller

# Setup Orbbec related rules
WORKDIR  /root/robot_ws/src/OrbbecSDK_ROS2/orbbec_camera/scripts
RUN bash install_udev_rules.sh

WORKDIR /root/robot_ws
RUN rosdep install --from-paths src --ignore-src -r -y

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build

RUN rm -rf build log src

# Setup entrypoint
COPY ./script/entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]