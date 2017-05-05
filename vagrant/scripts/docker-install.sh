#!/bin/bash

USERNAME=$1

curl -sS https://raw.githubusercontent.com/brainstation-au/shortcuts/master/docker/install-ubuntu.sh | bash /dev/stdin $USERNAME
