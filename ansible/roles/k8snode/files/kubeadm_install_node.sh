#!/bin/bash
#####################
# init k8s node
install_log=/tmp/kubeadm_install_node.log
if [ `ls /etc/kubernetes/kubelet.conf &>/dev/null;echo $?` -ne 0 ];then
    kubeadm join 192.168.147.139:16443 --token abcdef.0123456789abcdef \
	--discovery-token-ca-cert-hash sha256:b72731bd3a76a3e741c7a7d4c795bb36a18b28e615e7297bd90c2418c0a9cfe7   &> $install_log
fi
