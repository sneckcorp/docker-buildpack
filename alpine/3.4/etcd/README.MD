This docker image for quick deploy etcd cluster in AWS ECS service or on EC2 instances

It calls AWS metadata API on the start to discover IP address.
So can work on other cloud providers as well.

You need to get unique token from public etcd discovery service. Read more at:
https://coreos.com/os/docs/latest/cluster-discovery.html

For example to create new token for new cluster of 3 instances:

    curl -w "\n" 'https://discovery.etcd.io/new?size=3'

answer will be something like:

    https://discovery.etcd.io/812bf4a88df43da746900a93f1633233

Then you can use 812bf4a88df43da746900a93f1633233 as a token

And your docker run string will be:

    docker run -d -e ETCD_TOKEN=812bf4a88df43da746900a93f1633233 sneck/etcd-aws
