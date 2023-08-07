function ghr
    set -l organization $argv[1]
    set -l visibility $argv[2]
    
    if [ "$visibility" = "public" ]
        set private "--public"
    else
        set private "--private"
    end
    
    set -l current_directory (basename $PWD)
    set -l source_directory (git rev-parse --show-toplevel)
    
    gh repo create $organization/$current_directory --source $source_directory $private
end

