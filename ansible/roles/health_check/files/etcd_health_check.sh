#!/bin/bash

export ETCDCTL_API=3
etcd1=master1
etcd2=master2
etcd3=master3
ETCDCTL=/usr/local/bin/etcdctl
#check_cmd="ETCDCTL_API=3 $ETCDCTL --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key --write-out=table --endpoints=master1:2379,master2:2379,master3:2379"
check_cmd="$ETCDCTL --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key --write-out=table --endpoints=master1:2379,master2:2379,master3:2379"
function endpoint_check() {
   $check_cmd endpoint health
}

function member_check() {
  $check_cmd member list
}

function endpoint_status() {
  $check_cmd endpoint status
}

case $1 in 
"endpoint_check")
    endpoint_check
    ;;
"member_check")
    member_check
    ;;
"endpoint_status")
    endpoint_status
    ;;
*)
    echo "$0 [endpoint_check|member_check|endpoint_status]"
esac
