export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1="\W\$ "
export CLICOLOR=1

export TERM=xterm-256color
export TERMCAP=

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

alias be='bundle exec'

function getCerts() {
    echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text
}

function do_times() {
    fun=$1
    times=$2
    for i in $(seq 1 $times)
    do
        $fun
    done
}

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# build erlang with docs
export KERL_BUILD_DOCS=yes

# select java version
export JAVA_HOME=$(/usr/libexec/java_home -v 12.0.2)

# mysql
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
