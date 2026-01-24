
# like !! in bash
# Source - https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell
# Posted by NotTheDr01ds
# Retrieved 2026-01-22, License - CC BY-SA 4.0
function last_history_item
    echo "sudo $history[1]"
end
abbr -a kut --position anywhere --function last_history_item
abbr -a pls --position anywhere --function last_history_item
