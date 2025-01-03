ARG ROS2_DISTRO=jazzy

FROM ros:$ROS2_DISTRO-perception
ARG ROS2_DISTRO

ENV ROS2_DISTRO=$ROS2_DISTRO
 
RUN apt-get update

# Install navigation and slam packages
RUN apt-get install ros-${ROS2_DISTRO}-navigation2 ros-${ROS2_DISTRO}-nav2-bringup ros-${ROS2_DISTRO}-slam-toolbox -y

# Setup build tools and libraries
RUN apt-get install python3-colcon-common-extensions -y

RUN mkdir -p /robot_ws
  
# Setup entrypoint
COPY ./script/entrypoint.sh  /robot_ws/entrypoint.sh

# Set the workdir
WORKDIR /robot_ws
ENTRYPOINT ["/robot_ws/entrypoint.sh"]