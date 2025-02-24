# Containerized Cassandra Cluster

The repository you're looking at contains a relatively clean and
simple containerized Apache Cassandra cluster for local testing.

The approach is based on the [official Cassandra
image](https://hub.docker.com/_/cassandra/) (maintained on [Docker
Hub](https://docs.docker.com/docker-hub/official_images/) ), but still
lets you control all the Cassandra node configuration files without
requiring you to build custom Docker images.

I created this fork from a now defunct repository because that
original repository didn't quite do what I wanted.  The fork should
create a Docker Compose cluster with as many Cassandra nodes as are
specified in the `docker-compose.yml` file in a fairly turnkey way
according to the quick start instructions below.

I usually use what's here on macOS using [Docker Desktop on
Mac](https://docs.docker.com/desktop/install/mac-install/), without
too much fuss.  Things also work under Ubuntu, as long as you `sudo`
as appropriate when running Docker commands and the included scripts
that rely on them.

## Quick Start
```
# NOTE: Run the next two commands ONLY during your initial setup...
./setup-config.sh
docker compose up -d

# Check the cluster status
docker exec cass1 nodetool status
```
   - The above will bring up a 3 node Cassandra cluster. You can
     configure the number of Cassandra containers in
     [docker-compose.yml](docker-compose.yml)
   - Cassandra data is stored under `./data/` on the host and preserved even if the cluster is destroyed
   - Cassandra configuration files are under `./etc/`.
   - Each `./scratch/node_name` directory is mounted as a volume at
     `/var/lib/scratch` in the named node's container.  You might find
     these directories useful for staging data or scripts or as per
     node filesystem scratch space you can easily edit from your
     Docker host machine.
   - You can access the cluster from any apps you might write on `localhost:9042`
   - Or you can add a container with your app to the
     [docker-compose.yml](docker-compose.yml) and make it run as part
     of the cluster

If you want to start fresh again (no data, and a vanilla configuration):
```
sudo rm -r ./data/* ./etc/* ./scratch/*
```

Or you can use the `teardown.sh` script to destroy the containers and
their persisted data and configuration.

## Destroying the cluster
```
docker compose down
```

If you do just the above the nodes' data and files should be preserved.

## nodetool

You can exec Cassandra's `nodetool` one a given node with:
```
docker exec cass1  nodetool ...
```
Alternately you can use the `nodetool.sh` script to save yourself a
bit of typing as follows:
```
nodetool.sh node_container_name [nodetool arguments]
```

## cqlsh

You can run CQL commands as follows:
```
docker exec cass1 cqlsh -e "DESCRIBE keyspaces"

# Or in interactive shell mode
docker exec -it cass1 cqlsh
```
or using the provided `cqlsh.sh` script:
```
cqlsh.sh node_container_name [other_args_to_cqlsh]
```
to get an interactive shell on the specified node.

## Cassandra logs

Obtain a node's logs in the standard Docker manner with:
```
docker logs -f cass1
```

## Basic configuration
Edit [docker-compose.yml](docker-compose.yml) for your needs, keeping
in mind the following:

   - An [official docker image](https://hub.docker.com/_/cassandra/)
     for cassandra must be used
   - You should specify an explicit version tag
   - Each cassandra container needs to have two volumes configured,
     one for data and one for config files
   - Some basic Cassandra configuration can be done through
     `CASSANDRA_` environment variables
   - Check the syntax with `docker-compose config` before running
     `./setup-config.sh`

## Cassandra configuration

If you need more advanced configuration, you can edit config files
(eg. cassandra.yaml) for each node under `etc/<node>/` and simply run


```
docker-compose restart
```

## Summary of Basic Helper Scripts

The following scripts may save a bit of typing when interacting with
the cluster.
   - `cqlsh.sh`: Open a CQL shell on the indicated node.
   - `nodetool.sh`: Run `nodetool` on the indicated node.
   - `teardown.sh`: Tear down the compose cluster and delete `etc` and
     `data` directories.
