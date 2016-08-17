# Kong in Docker 

This is the official Docker image for [Kong][kong-site-url].

# What is Kong?

Kong was built to secure, manage and extend Microservices & APIs. If you're building for web, mobile or IoT (Internet of Things) you will likely end up needing to implement common functionality on top of your actual software. Kong can help by acting as a gateway for any HTTP resource while providing logging, authentication and other functionality through plugins.

Powered by NGINX and Cassandra with a focus on high performance and reliability, Kong runs in production at Mashape where it has handled billions of API requests for over ten thousand APIs.

Kong's documentation can be found at [getkong.org/docs][kong-docs-url].

# How to use this image

First, Kong requires a running Cassandra or PostgreSQL cluster before it starts. You can either use the official Cassandra/PostgreSQL containers, or use your own.

## 1. Link Kong to either a Cassandra or PostgreSQL container

It's up to you to decide which datastore between Cassandra or PostgreSQL you want to use, since Kong supports both.

### Cassandra

Start a Cassandra container by executing:

```shell
$ docker run -d --name kong-database \
                -p 9042:9042 \
                cassandra:2.2
```

### Postgres

Start a PostgreSQL container by executing:

```shell
docker run -d --name kong-database \
                -p 5432:5432 \
                -e "POSTGRES_USER=kong" \
                -e "POSTGRES_DB=kong" \
                -e "POSTGRES_PASSWORD=kong" \
                postgres:9.4
```

### Start Kong

Once the database is running, we can start a Kong container and link it to the database container, and configuring the `DATABASE` environment variable with either `cassandra` or `postgres` depending on which database you decided to use:

```shell
$ docker run --name kong \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database:9042" \
    --link kong-database:kong-database \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8002:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    sneck/kong
```

```shell
$ docker run --name kong \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_POSTGRES_HOST=kong-database" \
    -e "KONG_POSTGRES_USER=kong" \
    -e "KONG_POSTGRES_PASSWORD=kong" \
    --link kong-database:kong-database \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8002:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    sneck/kong
```

**Note:** If Docker complains that `--security-opt` is an invalid option, just remove it and re-execute the command (it was introduced in Docker 1.3).

If everything went well, and if you created your container with the default ports, Kong should be listening on your host's `8000` ([proxy][kong-docs-proxy-port]), `8443` ([proxy SSL][kong-docs-proxy-ssl-port]) and `8001` ([admin api][kong-docs-admin-api-port]) ports. Port `7946` ([cluster][kong-docs-cluster-port]) is being used only by other Kong nodes.

You can now read the docs at [getkong.org/docs][kong-docs-url] to learn more about Kong.

## 2. Use Kong with a custom configuration (and a custom Cassandra/PostgreSQL cluster)

This container stores the [Kong configuration file](http://getkong.org/docs/latest/configuration/) in a [Data Volume][docker-data-volume]. You can store this file on your host (name it `kong.yml` and place it in a directory) and mount it as a volume by doing so:

```shell
$ docker run -d \
    -v /path/to/your/kong/configuration/directory/:/etc/kong/ \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    --name kong \
    sneck/kong
```

When attached this way you can edit your configuration file from your host machine and restart your container. You can also make the container point to a different Cassandra/PostgreSQL instance, so no need to link it to a Cassandra/PostgreSQL container.

## Reload Kong in a running container

If you change your custom configuration, you can reload Kong (without downtime) by issuing:

```shell
$ docker exec -it kong kong reload
```

This will run the [`kong reload`][kong-docs-reload] command in your container.

## Environment Variables
| NAME  | DESCRIPTION | DEFAULT  |
|---|---|---|
| KONG_NGINX_WORKING_DIR | The Kong working directory. Equivalent to nginx's prefix path. | /usr/local/kong/ |
| KONG_PROXY_LISTEN | Address and port on which the server will accept HTTP requests, consumers will make requests on this port.  | 0.0.0.0:8000 |
| KONG_PROXY_LISTEN_SSL | Same as proxy_listen, but for HTTPS requests.  | 0.0.0.0:8443|
| KONG_ADMIN_API_LISTEN | Address and port on which the admin API will listen to.  | 0.0.0.0:8001 |
| KONG_CLUSTER_LISTEN | Address and port used by the node to communicate with other Kong nodes in the cluster with both UDP and TCP messages. All the nodes in the cluster must be able to communicate with this node on this address. **Only IPv4 addresses are allowed (no hostnames).** | 0.0.0.0:7946  |
| KONG_CLUSTER_LISTEN_RPC | Address and port used by the node to communicate with the local clustering agent (TCP only, and local only).  | 127.0.0.1:7373  |
| KONG_SSL_CERT_PATH | The path to the SSL certificate and key that Kong will use when listening on the `https` port.  |   |
| KONG_SSL_KEY_PATH | The path to the SSL certificate and key that Kong will use when listening on the `https` port.  |   |
| KONG_DNS_RESOLVERS | Specify how Kong performs DNS resolution (in the `dns_resolvers_available` property) you want to use. Options are: "dnsmasq" (You will need dnsmasq to be installed) or "server".  | dnsmasq  |
| KONG_DNS_RESOLVERS_AVAILABLE_SERVER_ADDRESS |  A dictionary of DNS resolvers Kong can use, and their respective properties.  | 127.0.0.1:8053   |
| KONG_DNS_RESOLVERS_AVAILABLE_DNSMASQ_PORT |   | 8053  |
| KONG_CLUSTER_ADVERTISE_IP | Kong cluster advertise ip address  |   |
| KONG_CLUSTER_ADVERTISE_PORT | Kong cluster advertise port  | 7946 |
| KONG_CLUSTER_ADVERTISE | Address and port used by the node to communicate with other Kong nodes in the cluster with both UDP and TCP messages. All the nodes in the cluster must be able to communicate with this node on this address.  |   |
| KONG_CLUSTER_ENCRYPT | Key for encrypting network traffic within Kong. Must be a base64-encoded 16-byte key.  |   |
| KONG_CLUSTER_TTL_ON_FAILURE | The TTL (time to live), in seconds, of a node in the cluster when it stops sending healthcheck pings, maybe because of a failure.  |   |
| KONG_DATABASE | Specify which database to use. Only "cassandra" and "postgres" are currently available. |   |
| KONG_POSTGRES_HOST | PostgreSQL host  | 127.0.0.1  |
| KONG_POSTGRES_PORT | PostgreSQL port  | 5432  |
| KONG_POSTGRES_DATABASE | Name of the database used by Kong. Will be created if it does not exist. | kong  |
| KONG_POSTGRES_USER |   | PostgreSQL user  |
| KONG_POSTGRES_PASSWORD | PostgreSQL password  |   |
| KONG_CASSANDRA_CONTACT_POINTS |  Contact points to your Cassandra cluster. | 127.0.0.1:9042 |
| KONG_CASSANDRA_PORT | Port on which your cluster's peers (other than your contact_points) are listening on. | 9042  |
| KONG_CASSANDRA_KEYSPACE | Name of the keyspace used by Kong. Will be created if it does not exist.  | kong  |
| KONG_CASSANDRA_TIMEOUT | Connection and reading timeout (in ms).  | 5000  |
| KONG_CASSANDRA_REPLICATION_STRATEGY |  The name of the replica placement strategy class for the keyspace. Can be "SimpleStrategy" or "NetworkTopologyStrategy". | SimpleStrategy  |
| KONG_CASSANDRA_REPLICATION_FACTOR | For SimpleStrategy only. The number of replicas of data on multiple nodes.  | 1  |
| KONG_CASSANDRA_DATA_CENTERS_<NAME> | For NetworkTopologyStrategy only. The number of replicas of data on multiple nodes in each data center. <NAME> is data center name |  |
| KONG_CASSANDRA_CONSISTENCY | Consistency level to use.  | ONE  |
| KONG_CASSANDRA_SSL_ENABLE | if true, will connect to your Cassandra instance using TLS.  | false |
| KONG_CASSANDRA_SSL_VERIFY | if true, will verify the server certificate using the given CA file.  | false |
| KONG_CASSANDRA_SSL_CERTIFICATE_AUTHORITY | an absolute path to the trusted CA certificate in PEM format used to verify the server certificate.  |   |
| KONG_CASSANDRA_USERNAME | Cluster username  |   |
| KONG_CASSANDRA_PASSWORD | Cluster password  |   |
| KONG_SEND_ANONYMOUS_REPORTS | Kong will send anonymous reports to Mashape. This helps Mashape fixing bugs/errors and improving Kong.  | true  |
| KONG_MEMORY_CACHE_SIZE | A value specifying (in MB) the size of the internal preallocated in-memory cache.  | 128  |
| KONG_CONF | The NGINX configuration (or `nginx.conf`) that will be used for this instance.  |   |

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue][github-new-issue].

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue][github-new-issue], especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

[kong-site-url]: http://getkong.org
[kong-docs-url]: http://getkong.org/docs
[kong-docs-proxy-port]: http://getkong.org/docs/latest/configuration/#proxy_port
[kong-docs-proxy-ssl-port]: http://getkong.org/docs/latest/configuration/#proxy_listen_ssl
[kong-docs-admin-api-port]: http://getkong.org/docs/latest/configuration/#admin_api_port
[kong-docs-cluster-port]: http://getkong.org/docs/latest/configuration/#cluster_listen
[kong-docs-reload]: http://getkong.org/docs/latest/cli/#reload

[github-new-issue]: https://github.com/Mashape/docker-kong/issues/new
[docker-data-volume]: https://docs.docker.com/userguide/dockervolumes/