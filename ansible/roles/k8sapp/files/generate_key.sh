#!/bin/bash
#

if [ $# -ne 2 ];then
   echo "$0 certs_dir key_name"
   exit 2
fi

CERTS_DIR=$1
KEY_NAME=$2
if [ ! -d $CERTS_DIR ];then
    mkdir -p $CERTS_DIR
fi

cd $CERTS_DIR


# 创建key文件
openssl genrsa -out ${KEY_NAME}.key 2048

#证书请求
openssl req -days 36000 -new -out ${KEY_NAME}.csr -key ${KEY_NAME}.key -subj '/CN=${KEY_NAME}-cert'

#自签证书
openssl x509 -req -in ${KEY_NAME}.csr -signkey ${KEY_NAME}.key -out ${KEY_NAME}.crt
