export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1="\W\$ "
export CLICOLOR=1

export TERM=xterm-256color
export TERMCAP=

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# build erlang with docs
export KERL_BUILD_DOCS=yes

# select java version
export JAVA_HOME=$(/usr/libexec/java_home -v 12.0.2)

# mysql
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# ctags
alias tags='git ls-files | ctags -e -R --links=no -L-'
