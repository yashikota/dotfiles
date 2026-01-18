# SSHポートフォワーディングを設定
# Usage: fwd <port1> [port2 ...] <host>
# Example: fwd 8080 3000 myserver
fwd() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: fwd <port1> [<port2> ... <portN>] <host>"
        return 1
    fi

    local host="${@: -1}"
    local ports=("${@:1:$#-1}")

    for port in "${ports[@]}"; do
        if ssh -fNL "$port:localhost:$port" "$host"; then
            echo "Port forwarding established: $port:localhost:$port via $host"
        else
            echo "Failed to establish port forwarding for port $port"
        fi
    done
}
