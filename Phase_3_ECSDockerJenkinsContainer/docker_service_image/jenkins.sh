#! /bin/bash -e
#: "${JENKINS_ROOT:="/apps/jenkins"}"  GETs the env var
: "${JENKINS_WAR:="${JENKINS_ROOT}/bin/jenkins.war"}"
: #"${JENKINS_HOME:="${JENKINS_ROOT}/jenkins_home"}" GETs the env var
: "${COPY_REFERENCE_FILE_LOG:="${JENKINS_HOME}/copy_reference_file.log"}"
: # "${REF:="${JENKINS_ROOT}/ref"}"  GETs the env var

touch "${COPY_REFERENCE_FILE_LOG}" || { echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?"; exit 1; }
echo "--- Copying files at $(date)" >> "$COPY_REFERENCE_FILE_LOG"
find "${REF}" \( -type f -o -type l \) -exec bash -c '. $JENKINS_ROOT/scripts/jenkins-support; for arg; do copy_reference_file "$arg"; done' _ {} +

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  # shellcheck disable=SC2001
  effective_java_opts=$(sed -e 's/^ $//' <<<"$JAVA_OPTS $JENKINS_JAVA_OPTS")

  # read JAVA_OPTS and JENKINS_OPTS into arrays to avoid need for eval (and associated vulnerabilities)
  java_opts_array=()
  while IFS= read -r -d '' item; do
    java_opts_array+=( "$item" )
  done < <([[ $effective_java_opts ]] && xargs printf '%s\0' <<<"$effective_java_opts")

  readonly agent_port_property='jenkins.model.Jenkins.slaveAgentPort'
  if [ -n "${JENKINS_SLAVE_AGENT_PORT:-}" ] && [[ "${effective_java_opts:-}" != *"${agent_port_property}"* ]]; then
    java_opts_array+=( "-D${agent_port_property}=${JENKINS_SLAVE_AGENT_PORT}" )
  fi

  readonly lifecycle_property='hudson.lifecycle'
  if [[ "${JAVA_OPTS:-}" != *"${lifecycle_property}"* ]]; then
    java_opts_array+=( "-D${lifecycle_property}=hudson.lifecycle.ExitLifecycle" )
  fi

  if [[ "$DEBUG" ]] ; then
    java_opts_array+=( \
      '-Xdebug' \
      '-Xrunjdwp:server=y,transport=dt_socket,address=*:5005,suspend=y' \
    )
  fi

  jenkins_opts_array=( )
  while IFS= read -r -d '' item; do
    jenkins_opts_array+=( "$item" )
  done < <([[ $JENKINS_OPTS ]] && xargs printf '%s\0' <<<"$JENKINS_OPTS")

  FUTURE_OPTS=""
  if [[ "$JENKINS_ENABLE_FUTURE_JAVA" ]] ; then
    FUTURE_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED
        --add-opens=java.base/java.io=ALL-UNNAMED
        --add-opens java.base/java.util=ALL-UNNAMED
        --add-opens java.base/java.util.concurrent=ALL-UNNAMED
        "
  fi

  # --add-opens won't get expanded properly with quotes around it
  # shellcheck disable=SC2086
  echo exec java -Duser.home="$JENKINS_HOME" ${FUTURE_OPTS} "${java_opts_array[@]}" -jar ${JENKINS_WAR} "${jenkins_opts_array[@]}" "$@" 
  exec java -Duser.home="$JENKINS_HOME" ${FUTURE_OPTS} "${java_opts_array[@]}" -jar ${JENKINS_WAR} "${jenkins_opts_array[@]}" "$@"
  # sleep 50000
fi

# As argument is not jenkins, assume user wants to run a different process, for example a `bash` shell to explore this image
exec "$@"
