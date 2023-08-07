function ghr
    set -l organization $argv[1]
    set -l visibility $argv[2]
    
    if [ "$visibility" = "public" ]
        set visibility "--public"
    else
        set visibility "--private"
    end
    
    set -l current_directory (basename $PWD)
    set -l source_directory (git rev-parse --show-toplevel)
    
    gh repo create $organization/$current_directory --source $source_directory $visibility
end

