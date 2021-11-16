#!/bin/bash
#
#  descript: distribute ssh-pub-key command file etc.

BASEDIR=$(dirname `readlink -f $0`)

function runcmd(){
 #<host> <username> <password> <command>
  if [ $# -ne 4 ];then
    echo -e "func param error\nusage: func <host> <username> <password> <command>"
    exit 1
  fi   
  host=$1
  user=$2
  pass=$3
  cmd=$4
  
  $BASEDIR/scripts/expect_ssh_cmd.sh $host $user "$pass" "$cmd"
  
  
}

function scpfile(){
 #<host> <username> <password> <sourcefile> <destinationfile>
  if [ $# -ne 5 ];then
    echo -e "func param error\nusage: func <host> <username> <password> <sourcefile> <destinationfile>"
    exit 1
  fi
  host=$1
  user=$2
  pass=$3
  srcfile=$4
  desfile=$5

  $BASEDIR/scripts/expect_scp_file.sh $host $user "$pass" "$srcfile" "$desfile"


}

function scpkey(){
 # <host> <username> <password>
  if [ $# -ne 3 ];then
    echo -e "func param error\nusage: func <host> <username> <password>"
    exit 1
  fi
  host=$1
  user=$2
  pass=$3

  $BASEDIR/scripts/expect_ssh_key.sh $host $user "$pass"
}

function generate_sshkey(){
  if [ $# -ne 1 ];then
    echo -e "func param error\nusage: func <username>"
    exit 1
  fi
  username=$1
  if [ "root" == $username ];then
      ssh-keygen -t rsa -P "" -f /home/$username/.ssh/id_rsa
  else
      su -p $username -s /bin/bash -c "ssh-keygen -t rsa -P '' -f /home/$username/.ssh/id_rsa"
  fi
}


case "$1" in

"runcmd")
    shift
    runcmd $1 $2 "$3" "$4"
    ;;
"scpfile")
    shift
    scpfile $1 $2 "$3" "$4" "$5"
    ;;
"scpkey")
    shift
    scpkey $1 $2 "$3"
    ;;
"generate_sshkey")
    shift
    generate_sshkey $1
    ;;
"forloop")
    shift
    HOST_FILE=`ls $BASEDIR/hosts`
    for i in $(seq `cat $HOST_FILE|wc -l`)
    do
        hostline=`sed -n "${i}p" $HOST_FILE`
        host=`echo $hostline|awk '{print $1}'`
        hostname=`echo $hostline|awk '{print $2}'`
        user=`echo $hostline|awk '{print $3}'`
        pass=`echo $hostline|awk '{print $4}'`
        if [ "runcmd" == "$1" ];then
            cmd=$2
            runcmd $host $user "$pass" "$cmd"
         elif [ "scpfile" == "$1" ];then
            srcfile=$2
            desfile=$3
            scpfile $host $user "$pass" "$srcfile" "$desfile"
         elif [ "scpkey" == "$1" ];then
            user=$2
            pass=$3
            scpkey $host $user $pass
            scpkey $hostname $user $pass
            cp ~/.ssh/known_hosts /home/${user}/.ssh/known_hosts
         elif [ "set-hostname" == "$1" ];then
            runcmd $host $user "$pass" "hostnamectl set-hostname --static $hostname"
         elif [ "createuser" == "$1" ];then
            newuser=$2
            newpass=$3
            hassudo=$4
            if [ "sudo" == $hassudo ];then
                runcmd $host $user "$pass" "useradd $newuser && echo $newpass |passwd --stdin $newuser && echo '$newuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$newuser"
            else
                runcmd $host $user "$pass" "useradd $newuser && echo $newpass |passwd --stdin $newuser"
            fi
         else
            echo """$0 forloop [runcmd|scpfile|scpkey|set-hostname|createuser]
                runcmd <command>
                scpfile <srcfile> <desfile>
                scpkey <username> <password>
                set-hostname
                createuser <newuser> <newpass> [sudo]
                """
            break
         fi
    done
   ;;
*)
    echo -e """$0 [runcmd|scpfile|scpkey|generate_ssh_key|forloop]
    runcmd <host> <username> <password> <command>
    scpfile <host> <username> <password> <sourcefile> <destinationfile>
    scpkey <host> <username> <password>
    generate_sshkey <username>
    """
esac
