#!/bin/bash

# nexus= IP of nexus 
nexus=192.168.1.83

npm config set registry http://nexus:8081/repository/npm/

# to revert back, edit /home/user/.npmrc and delete registry line
