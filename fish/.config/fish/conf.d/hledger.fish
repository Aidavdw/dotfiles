# Always open hledger in strict mode.
# Strict mode catches errors.
abbr -a --position command hledger 'hledger -s'

abbr -a --position command ihledger "hledger-iadd --date-format '[[%y-]%m-]%d'"
abbr -a --position command hledger-iadd "hledger-iadd --date-format '[[%y-]%m-]%d'"
