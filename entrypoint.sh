#!/bin/bash

IP_V4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4);
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id);
PUBLIC_V4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4);

#Run instructions:
#     docker run -d -e ETCD_TOKEN=<your token> <docker image name>"
# More instructions
# https://coreos.com/os/docs/latest/cluster-discovery.html"
#If ETCD_TOKEN is not specified we run it as a private discovery cluster

if [ -z $ETCD_TOKEN ]
 then
  cd /opt/etcd
  ./etcd \
    -name etcd \
    -advertise-client-urls http://$PUBLIC_V4:2379,http://$PUBLIC_V4:4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://$PUBLIC_V4:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -initial-cluster etcd0=http://$PUBLIC_V4:2380 \
    -initial-cluster-token etcd-cluster-1 \
    -initial-cluster-state new
else
 cd /opt/etcd
 ./etcd \
    -name $INSTANCE_ID \
    -advertise-client-urls http://$IP_V4:2379,http://$IP_V4:4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://$IP_V4:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -discovery https://discovery.etcd.io/$ETCD_TOKEN
fi
