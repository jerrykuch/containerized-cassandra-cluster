#!/bin/bash

if [ $# -eq 0 ];
then echo "Usage:  cqlsh.sh node_container_name [other_args_to_cqlsh]"
     exit
fi

docker exec -it $1 cqlsh ${@:2}


