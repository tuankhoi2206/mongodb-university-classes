#!/bin/bash

# ============================================================================== #
# MIT License                                                                    #
#                                                                                #
# Copyright (c) 2017 Donato Rimenti                                              #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal  #
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in     #
# all copies or substantial portions of the Software.                            #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  #
# SOFTWARE.                                                                      #
# ============================================================================== #
#                                                                                #
# DESCRIPTION : Solution for MongoDB University M310's Homework 3.2.             #
# AUTHOR : Donato Rimenti                                                        #
# COPYRIGHT : Copyright (c) 2017 Donato Rimenti                                  #
# LICENSE : MIT                                                                  #
#                                                                                #
# ============================================================================== #

# Kills all the mongo process and waits for them to exit.
pkill mongod
sleep 3

# Creates the directory structure.
mkdir -p ~/M310-HW-3.2/r0
mkdir -p ~/M310-HW-3.2/r1
mkdir -p ~/M310-HW-3.2/r2

# Starts the mongo instances.
mongod --dbpath ~/M310-HW-3.2/r0 --logpath ~/M310-HW-3.2/r0/mongo.log --port 31320 --fork --replSet HW-3.2 --auditDestination file --auditFormat JSON --auditPath ~/M310-HW-3.2/r0/auditLog.json --auditFilter '{ "users.user": "steve" }'
mongod --dbpath ~/M310-HW-3.2/r1 --logpath ~/M310-HW-3.2/r1/mongo.log --port 31321 --fork --replSet HW-3.2 --auditDestination file --auditFormat JSON --auditPath ~/M310-HW-3.2/r1/auditLog.json --auditFilter '{ "users.user": "steve" }'
mongod --dbpath ~/M310-HW-3.2/r2 --logpath ~/M310-HW-3.2/r2/mongo.log --port 31322 --fork --replSet HW-3.2 --auditDestination file --auditFormat JSON --auditPath ~/M310-HW-3.2/r2/auditLog.json --auditFilter '{ "users.user": "steve" }'

# Initiates the replica set.
mongo admin --port 31320 --eval "rs.initiate()"
sleep 3

# Adds the other members to the replica set.
mongo admin --port 31320 --eval 'rs.add("database.m310.mongodb.university:31321")'
mongo admin --port 31320 --eval 'rs.add("database.m310.mongodb.university:31322")'

# Creates the new user.
mongo admin --port 31320 --eval 'db.createUser({user: "steve", pwd: "secret", roles: ["root"]})'

# Validates the homework.
./validate-hw-3.2.sh