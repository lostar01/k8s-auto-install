#!/usr/bin/expect

if {$argc < 5} {
    puts "Usage: cmd <host> <username> <password> <sourcefile> <destinationfile>"
    exit 1
}

set timeout -1
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set srcfile [lindex $argv 3]
set destfile [lindex $argv 4]
spawn scp -r $srcfile $username@$host:$destfile
expect {
    "password" {send "$password\r";}
    "yes/no" {send "yes\r";exp_continue}
}

expect eof
exit