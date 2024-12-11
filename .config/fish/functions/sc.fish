# sc: Open remote files in VS Code via SSH
function sc
    set -l port 22
    set -l args $argv

    # Parse options
    while test (count $args) -gt 0
        switch $args[1]
            case -p --port
                if test (count $args) -lt 2
                    echo "Error: Missing value for port option"
                    return -1
                end
                set port $args[2]
                set args $args[3..-1]
            case '*'
                break
        end
    end
    if test (count $args) -eq 0
        echo "usage: sc [-p port] host[:dir]"
        return -1
    end

    # Extract host and dir
    set destination $args[1]
    set host (string split ":" "$destination")[1]
    set dir (string split ":" "$destination" | tail -n1)

    # Fix dir if ':' does not exist
    if test "$host" = "$dir"
        set dir ""
    end

    # Default path
    set user (ssh -p $port "$host" whoami)
    set basedir "/home/$user/prj"

    # Resolve dir if relative path
    if test (string sub -l 1 -- "$dir") != "/"
        set dir "$basedir/$dir"
    end

    # Open with VS Code
    code --folder-uri "vscode-remote://ssh-remote+$host:$port$dir"
end
