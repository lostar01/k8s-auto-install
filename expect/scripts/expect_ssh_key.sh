#!/usr/bin/expect

if {$argc < 3} {
    puts "Usage: cmd <host> <username> <password>"
    exit 1
}

set timeout -1
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]

spawn ssh-copy-id -i /home/$username/.ssh/id_rsa.pub ${username}@$host
expect {
    "password" {send "$password\r";}
    "yes/no" {send "yes\r";exp_continue}
}
expect eof
exit