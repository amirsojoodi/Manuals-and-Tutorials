#!/bin/bash

sudo npm install -g bower-nexus3-resolver

# Edit file /home/user/.bowerrc and put these lines in it:
# {
#   "registry" : {
#     "search" : [ "http://172.16.144.29:8081/repository/bower" ]
#    },
#  "resolvers" : [ "bower-nexus3-resolver" ]
# }
