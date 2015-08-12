#!/usr/bin/env sh
#
# Service.sh for pydio

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="pydio"
version="6.0.8"
description="Pydio is an open source software solution for file sharing and synchronization"
depends="apache"
webui=":8080/pydio"

prog_dir="$(dirname "$(realpath "${0}")")"
conffile="${prog_dir}/pydio.conf"
apachefile="${DROBOAPPS_DIR}/apache/etc/includes/pydio.conf"
daemon="${DROBOAPPS_DIR}/apache/service.sh"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

start() {
#  chown -R nobody "${prog_dir}/www/data"
#  find "${prog_dir}/www/" -name .htaccess -exec chown -R nobody {} \;
  cp -vf "${conffile}" "${apachefile}"
  "${daemon}" restart || true
  return 0
}

is_running() {
  if [ -e "${apachefile}" ]; then
    return 0
  fi
  return 1
}

stop() {
  rm -vf "${apachefile}"
  "${daemon}" restart || true
  return 0
}

force_stop() {
  stop
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"
