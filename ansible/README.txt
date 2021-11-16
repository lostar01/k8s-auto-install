# k8s auto install Readme

.
|-- README.txt           #k8s auto install documention
|-- etcd_manager.yml     #etcd manager playbook
|-- group_vars           #k8s auto install global variables
|   `-- all
|-- health_check.yml     #k8s health check playbook
|-- hosts                #ansible hosts 
|-- k8s_app_install.yml  #k8s common application installation 
|-- roles                #playbook role
|   |-- common           #apply all node
|   |-- haproxy          #apply haproxy node
|   |-- health_check     #health check playbook
|   |-- k8s              #apply all k8s node
|   |-- k8sapp           #k8s app install
|   |-- k8smanager       #k8s manager
|   |-- k8smaster        #apply k8s master node
|   |-- k8snode          #apply k8s node 
|   `-- keepalived       #apply keepalived node
`-- site.yml             #the playbook entrance



