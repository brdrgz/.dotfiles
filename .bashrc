export PS1="\W\$ "
export CLICOLOR=1

export TERM=xterm-256color
export TERMCAP=

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# build erlang with docs
export KERL_BUILD_DOCS=yes

# prevent erl_crash.dump from popping up in other projects
export ERL_CRASH_DUMP=/tmp/erl_crash.dump

# select java version
export JAVA_HOME=$(/usr/libexec/java_home -v 12.0.2)

# mysql
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# ctags
alias tags='git ls-files | ctags -e -R --links=no -L-'

# Homebrew completions
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# Emacs shell
export ESHELL=/usr/local/bin/bash
