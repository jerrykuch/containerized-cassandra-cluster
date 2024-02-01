#!/bin/bash
set -e  #fail fast

# Get Cassandra version from the Docker Compose...
CASSANDRA_VERSION=`docker compose config | grep 'image:.*cassandra:' | head -1 | awk -F":" '{ print $NF}'`

# Pull image with specified version
docker image pull cassandra:$CASSANDRA_VERSION

# Start up a dummy container so we can steal its /etc/cassandra directory...
docker run --rm -d --name tmp cassandra:$CASSANDRA_VERSION
docker cp tmp:/etc/cassandra/ etc_cassandra_${CASSANDRA_VERSION}_vanilla/
docker stop tmp

# For each of the containers we want in our cluster, copy over the
# /etc/cassandra directory we pillaged from the dummy container earlier.
# We get the container names from the Docker Compose configuration.
etc_volumes=$(docker compose config | grep 'container_name:.*' | awk -F ": " '{print $NF}')

for v in ${etc_volumes}; do
    mkdir -p ./etc/$v
    cp -r etc_cassandra_${CASSANDRA_VERSION}_vanilla/* ./etc/$v
done

# After the script runs we should have 'etc' and 'data' directories, each
# with one subdirectory for each Cassandra node that was defined in the
# docker-compose.yml file.
