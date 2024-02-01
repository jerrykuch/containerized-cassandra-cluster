#!/bin/bash

if [ $# -eq 0 ];
then
    echo "Use: teardown.sh ANY_ARG_AT_ALL"
    echo "     To destroy the containers and any persisted data or config."
    exit
fi


docker compose down

rm -rf etc data
