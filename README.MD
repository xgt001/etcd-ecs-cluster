## etcd-ecs-cluster ##

Original Repository: [Feedvisor](https://github.com/feedvisor/etcd-ecs-cluster)

This docker image for quick deploy etcd cluster in AWS ECS service or on EC2 instances

It calls AWS metadata API on the start to discover IP address.
So can work on other cloud providers as well.

### Running as a Private Node

Just use the container_def.json provided in the repository for the task definition in ECS. 

To do it via the console on the GUI: You will need to map the ports 2379,2380 and 4001 ports with Docker Host instance. That's it.

### Running as Public Discovery Service 

To run it as a public discovery service, you need to fetch unique token from public etcd discovery service. Read more at:
https://coreos.com/os/docs/latest/cluster-discovery.html

For example to create new token for new cluster of 3 instances:

    curl -w "\n" 'https://discovery.etcd.io/new?size=3'

answer will be something like:

    https://discovery.etcd.io/812bf4a88df43da746900a93f1633233

Then you can use 812bf4a88df43da746900a93f1633233 as a token

And your docker run string will be:

    docker run -d -e ETCD_TOKEN=812bf4a88df43da746900a93f1633233 feedvisor/etcd-ecs-cluster

###Getting Started with ETCD

This is a good place to get started: 

https://coreos.com/etcd/docs/latest/getting-started-with-etcd.html
