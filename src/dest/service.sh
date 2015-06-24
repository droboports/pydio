#!/usr/bin/env sh
#
# Service.sh for pydio

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="pydio"
version="6.0.7"
description="Pydio server"
depends="apache2"
webui="WebUI"

prog_dir="$(dirname "$(realpath "${0}")")"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  . "${prog_dir}/libexec/service.subr"
fi

start() {
  chown -R nobody "${prog_dir}/www/data"
  chown -R nobody "${prog_dir}/www/.htaccess"
  ln -fs "${prog_dir}/pydio.conf" "${DROBOAPPS_DIR}/apache2/etc/includes/pydio.conf"
  "${DROBOAPPS_DIR}/apache2/service.sh" restart
  return 0
}

is_running() {
  if [ -e "${DROBOAPPS_DIR}/apache2/etc/includes/pydio.conf" ]; then
    return 0
  fi
  return 1
}

is_stopped() {
  if [ ! -e "${DROBOAPPS_DIR}/apache2/etc/includes/pydio.conf" ]; then
    return 0
  fi
  return 1
}

stop() {
  rm -f "${DROBOAPPS_DIR}/apache2/etc/includes/pydio.conf"
  "${DROBOAPPS_DIR}/apache2/service.sh" restart
  return 0
}

force_stop() {
  rm -f "${DROBOAPPS_DIR}/apache2/etc/includes/pydio.conf"
  "${DROBOAPPS_DIR}/apache2/service.sh" restart
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o pipefail # propagate last error code on pipe
set -o xtrace   # enable script tracing

main "${@}"
