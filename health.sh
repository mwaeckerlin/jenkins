#!/bin/bash

/health-dockindock.sh && wget -qO- http://localhost:8080/login | grep -q '<html'
