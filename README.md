
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# GUI not displaying in Docker container on Linux.
---

This incident type occurs when a software engineer is working in a Linux environment and uses Docker to launch a containerized GUI application, but the GUI does not display on their screen. This could be due to a number of reasons, such as incorrect configuration of the Docker container or display settings, missing dependencies, or incompatible graphics drivers. This can cause frustration and hinder progress for the engineer, as they are unable to visualize and interact with the application as intended.

### Parameters
```shell
export CONTAINER_NAME="PLACEHOLDER"

export APPLICATION_NAME="PLACEHOLDER"

export IMAGE_NAME="PLACEHOLDER"

export YOUR_GUI_COMPONENT="PLACEHOLDER"
```

## Debug

### Check if the container is running
```shell
docker ps
```

### Check if the correct display is set
```shell
echo $DISPLAY
```

### Check if the X11 socket is mounted
```shell
docker inspect ${CONTAINER_NAME} | grep -i mounts
```

### Check if the application is installed in the container
```shell
docker exec ${CONTAINER_NAME} which ${APPLICATION_NAME}
```

### Check if the user has the necessary permissions
```shell
xhost +local:root
```

### Check if the container has access to the host's graphics drivers
```shell
docker run -it --rm --device /dev/dri ${IMAGE_NAME} glxinfo | grep "OpenGL vendor string"
```

### The Docker image used to launch the containerized GUI application may be missing necessary dependencies or libraries required for the GUI to display properly.
```shell
bash

#!/bin/bash



# Replace with the name of the Docker image being used

DOCKER_IMAGE=${IMAGE_NAME}



# Check if the Docker image exists on the system

if ! docker image inspect $DOCKER_IMAGE &> /dev/null; then

  echo "ERROR: Docker image '$DOCKER_IMAGE' not found on the system."

  exit 1

fi



# Run a test container to check for missing dependencies

docker run --rm -it $DOCKER_IMAGE ldd ${APPLICATION_NAME}



# Check the output of the above command for any missing libraries or dependencies

# If any are found, install them on the host system and try running the container again


```

## Repair

### Verify that the Docker container has access to the display server, either by setting the DISPLAY environment variable or by mounting the X11 socket file.
```shell


#!/bin/bash



# Set the DISPLAY environment variable

export DISPLAY=${DISPLAY_SERVER_ADDRESS}:0



# Mount the X11 socket file

docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY ${DOCKER_IMAGE_NAME}


```