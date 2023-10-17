

#!/bin/bash



# Set the DISPLAY environment variable

export DISPLAY=${DISPLAY_SERVER_ADDRESS}:0



# Mount the X11 socket file

docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY ${DOCKER_IMAGE_NAME}