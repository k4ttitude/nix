function _fzf_search_zoxide --description "Search zoxide directory history and append selection to commandline"
    set -f dir_selected (
        z -l | \
        _fzf_wrapper --prompt="Zoxide> " \
                    --query (commandline --current-token) \
                    --preview="ls -l {}" \
                    --preview-window="bottom:4:wrap" \
                    $fzf_dir_opts | 
        sed 's/[0-9.]*[[:space:]]*//'
    )

    if test $status -eq 0
        # Get the current command line content and cursor position
        set -f cmdline (commandline)
        set -f cursor (commandline -C)

        # If there's already content, add a space before appending
        if test -n "$cmdline"
            set -f dir_selected " $dir_selected"
        end

        # Append the selected directory to the current command line
        commandline -i -- "$dir_selected"
    end

    commandline --function repaint
end
