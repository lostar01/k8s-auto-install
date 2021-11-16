#!/bin/bash
#####################
# init k8s node
install_log=/tmp/kubeadm_install_node.log
if [ `ls /etc/kubernetes/kubelet.conf &>/dev/null;echo $?` -ne 0 ];then
    kubeadm join 192.168.147.139:16443 --token abcdef.0123456789abcdef \
	--discovery-token-ca-cert-hash sha256:fbb7630ff1cd017e485cad0869fe0f28d4eef447f30449fa1a08732752ec4f81   &> $install_log
fi
