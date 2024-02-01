#!/bin/bash

if [ $# -eq 0 ];
then echo "Usage:  nodetool.sh node_container_name [nodetool arguments]"
     exit
fi

docker exec $1 nodetool ${*:2}
