# Containerized Cassandra Cluster

Clean and simple containerized Apache Cassandra cluster for local
testing. A modern alternative to
[ccm](https://github.com/digitalis-io/dcc).


This approach is based on [official
image](https://hub.docker.com/_/cassandra/) (maintained by [Docker
Hub](https://docs.docker.com/docker-hub/official_images/) ), but still
lets you control all the config files without a need to build a custom
image. Which is described in more details in this [blog
post](https://digitalis.io/blog/containerized-cassandra-cluster-for-local-testing/)

I created this fork because the original
[ccc](https://github.com/digitalis-io/ccc) didn't quite do what I
wanted.  The fork should create a Docker Compose cluster with as many
Cassandra nodes as are specified in the `docker-compose.yml` file in a
fairly turnkey way according to the quick start instructions below.

What's here works on macOS using [Docker Desktop on
Mac](https://docs.docker.com/desktop/install/mac-install/),
at least for me, without too much fuss.

## Quick start
```
./setup-config.sh
docker-compose up -d

# Check the cluster status
docker exec cass1  nodetool status
```
   - The above will bring up a 3 node Cassandra cluster. You can
     configure the number of Cassandra containers in
     [docker-compose.yml](docker-compose.yml)
   - Cassandra data is stored under `./data/` on the host and kept even if the cluster is destroyed
   - Cassandra configuration files are under `./etc/`.
   - The `scratch/node_name` directory is mounted as a volume at
     `/var/lib/scratch` in each node's container
   - You can access the cluster from your app on `localhost:9042`
   - Or you can add a container with your app to [docker-compose.yml](docker-compose.yml)

If you want to start fresh again (no data, vanilla config):
```
sudo rm -r ./data/* ./etc/* ./scratch/*
```

Or you can use the `teardown.sh` script to destroy the containers and
their persisted data and configuration.

## Destroying the cluster
```
docker-compose down
```

If you do just the above the nodes' files should be preserved.

## nodetool
```
docker exec cass1  nodetool ...
```

## cqlsh
```
docker exec cass1 cqlsh -e "DESCRIBE keyspaces"

# Or in interactive shell mode
docker exec -it cass1 cqlsh
```

## Cassandra logs
```
docker logs -f cass1
```

## Basic configuration
Edit [docker-compose.yml](docker-compose.yml) for your needs, keeping in mind the following:

   - An [official docker image](https://hub.docker.com/_/cassandra/) for cassandra must be used
   - You should specify an explicit version tag
   - Each cassandra container needs to have two volumes configured, one for data and one for config files
   - Some basic Cassandra configuration can be done through `CASSANDRA_` environment  variables
   - Check the syntax with `docker-compose config` before running `./setup-config.sh`

## Cassandra configuration

If you need more advanced configuration, you can edit config files
(eg. cassandra.yaml) for each node under `etc/<node>/` and simply run


```
docker-compose restart
```

A good example can be found in this [blog
post](https://digitalis.io/blog/containerized-cassandra-cluster-for-local-testing/)

## A Few Basic Helper Scripts

The following scripts may save a bit of typing when interacting with
the cluster.
   - `cqlsh.sh`
   - `nodetool.sh`
   - `teardown.sh`
