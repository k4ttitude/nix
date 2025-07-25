function kitty_scrollback_edit_command_buffer
    set --local --export VISUAL '~/.local/share/nvim/lazy/kitty-scrollback.nvim/scripts/edit_command_line.sh'
    edit_command_buffer
    commandline ''
end

kitty_scrollback_edit_command_buffer
