# bamboo-agent-arm-docker

This is a fork of the original Atlassian Bamboo agent server docker image modified to work on ARM architecture. The original repository can be found here: https://bitbucket.org/atlassian-docker/docker-bamboo-agent-base/src/master/

This repository consists of two branches: arm64v8 and arm32v7. Note that the image has Docker and Git added to the image for enhanced building capabilities.

## Overview

For instructions on how to run the docker images, please refer to the original Atlassian repository. The same instructions apply.

## Disclaimer

Note that Atlassian does not officially support Bamboo server on ARM. However, I have had no issues while running this custom docker image.
The only changes applied to the Dockerfile are basically changing the Java version that the image runs on.
