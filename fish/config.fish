function time --description="Bash time function"
  command time --portability $argv
end

set -g -x RANGER_LOAD_DEFAULT_RC FALSE
set -x VISUAL "nvim"
set -x EDITOR "nvim"

