#!/usr/bin/expect

if {$argc < 4} {
    puts "Usage: cmd <host> <username> <password> <command>"
    exit 1
}

set timeout -1
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set cmd [lindex $argv 3]
spawn ssh $username@$host
expect {
    "password" {send "$password\r";}
    "yes/no" {send "yes\r";exp_continue}
}
expect "$username" {send "$cmd\r"}
expect "$username" {send "exit\r"}
expect eof
exit