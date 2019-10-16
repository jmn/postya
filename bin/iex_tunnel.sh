#!/bin/bash

EPMD=/usr/bin/epmd

# Default values.
default_node="phx"
default_user="jmn"
default_server="i.jmnorlund.net"


function get_params()
{
    case $# in
	0)
	    node=$default_node
	    user=$default_user
	    server=$default_server
	    ;;
	3)
	    # OK, all parameters have been given.
	    ;;
	*)
	    echo "./iex_tunnuel.sh $default_node $default_user $default_server"
	    exit
	    ;;
    esac

    echo "node: $node"
    echo "user: $user"
    echo "server: $server"

}

function get_ports()
{
    while read line
    do
	if [ "$port1" = "" ]
	then
	    port1=`echo $line | grep running | cut -d ' ' -f 7`
	fi

	if [ "$port2" = "" ]
	then
	    port2=`echo $line | grep $node | cut -d ' ' -f 5`
	fi
    done < <(ssh $user@$server $EPMD -names)
}

function make_tunnel()
{
    echo $port1, $port2

    ssh -N -L $port1:$server:$port1 -L $port2:$server:$port2 $user@$server
}

function main()
{
    # Parameters.
    node=$1
    user=$2
    server=$3

    get_params $1 $2 $3
    get_ports
    make_tunnel
}

main $1 $2 $3