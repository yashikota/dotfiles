function fwd
    if test (count $argv) -lt 2
        echo "Usage: fwd <port1> [<port2> ... <portN>] <host>"
        return 1
    end

    set host $argv[-1]
    set ports $argv[1..-2]

    for port in $ports
        ssh -fNL $port:localhost:$port $host
        if test $status -eq 0
            echo "Port forwarding established: $port:localhost:$port via $host"
        else
            echo "Failed to establish port forwarding for port $port"
        end
    end
end
