# Use tiryoh/ros-desktop-vnc:noetic as the base image
FROM tiryoh/ros-desktop-vnc:noetic

# Set Environment Variables
ENV DEBIAN_FRONTEND = noninteractive

# LFS 파일 자동 다운로드 비활성화. commit from chohwan 
ENV GIT_LFS_SKIP_SMUDGE=1

# Install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        python3-pip \
        ros-noetic-vision-msgs && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

# Initialize catkin workspace
RUN mkdir -p ~/catkin_ws/src && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash ; cd ~/catkin_ws/src ; catkin_init_workspace" && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash ; cd ~/catkin_ws && catkin build" && \
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Install Git LFS
RUN apt-get update && \
    apt-get install -y git-lfs && \
    rm -rf /var/lib/apt/lists/* && \
    git lfs install

# Clone repository and install using requirements.txt (with debug)
RUN set -eux; \
    cd ~/catkin_ws/src; \
    git clone -b noetic-devel https://github.com/parkjaeil00/ultralytics_ros_jaeil.git; \
    ls -al ~/catkin_ws/src/ultralytics_ros_jaeil; \
    python3 -m pip --version; \
    python3 -m pip install --no-cache-dir -v -r ~/catkin_ws/src/ultralytics_ros_jaeil/requirements.txt


# Build the ROS package
RUN cd ~/catkin_ws && catkin build
