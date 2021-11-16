#!/bin/bash
#

yum install -y tcl expect ansible centos-release-ansible-29.noarch
yum install -y ansible.noarch


BASEDIR=$(dirname $(readlink -f "$0"))
#BASEDIR="$0"
echo $BASEDIR
#set execute permssion
chmod a+x ${BASEDIR}/scripts/expect_s*
