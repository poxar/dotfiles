PROJECTS=$HOME/Development
export PROJECTS

NOTEDIR=$HOME/Documents/Notes
export NOTEDIR

JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME

meeting() {
  n "Meeting/$(date +%Y-%m-%d) $*.md"
}

# Use rustup-init provided rust binaries
_pd_addpath "$HOME/.cargo/bin"

# Use brew provided curl if available
_pd_addpath '/usr/local/opt/curl/bin'

# Use sbt 0.13 series if available
_pd_addpath '/usr/local/opt/sbt@0.13/bin'

# Use postgres 9.5 series if available
_pd_addpath '/usr/local/opt/postgresql@9.5/bin'
