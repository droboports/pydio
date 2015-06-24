### PYDIO ###
_build_pydio() {
local VERSION="6.0.7"
local FOLDER="pydio-core-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/ajaxplorer/files/pydio/stable-channel/${VERSION}/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
sed -e "s|default=.php.|default=\"/mnt/DroboFS/Shares/DroboApps/apache2/bin/php\"|g" -i "plugins/core.ajaxplorer/manifest.xml"
mkdir -p "${DEST}/www"
cp -vfaR . "${DEST}/www"
popd
}

_build() {
  _build_pydio
  _package
}
