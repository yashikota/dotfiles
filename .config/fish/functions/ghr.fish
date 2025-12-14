function ghr
    set -l organization $argv[1]
    set -l visibility $argv[2]

    if not git rev-parse --is-inside-work-tree 2>/dev/null
        git init
    end

    if [ "$visibility" = "public" ]
        set visibility "--public"
    else
        set visibility "--private"
    end

    set -l current_directory (basename $PWD)
    set -l source_directory (git rev-parse --show-toplevel)

    gh repo create $organization/$current_directory $visibility --source $source_directory --remote=origin
end
