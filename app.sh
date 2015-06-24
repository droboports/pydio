### IMAGEMAGICK ###
_build_imagemagick() {
local VERSION="6.9.1-6"
local FOLDER="ImageMagick-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/imagemagick/files/6.9.1-sources/${FILE}"
local _APACHE_INCLUDE="${PWD}/../apache2/target/install/include"
local _APACHE_LIBS="${DROBOAPPS}/apache2/lib"
CPPFLAGS="${CPPFLAGS:-} -I${_APACHE_INCLUDE}"
LDFLAGS="-Wl,-rpath,${_APACHE_LIBS} -L${_APACHE_LIBS}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
PKG_CONFIG_PATH="${DROBOAPPS}/apache2/lib/pkgconfig" ./configure --host="${HOST}" --prefix="${DEPS}" --bindir="${DEST}/libexec" --libdir="${DEST}/lib" --disable-static --enable-zero-configuration
make
make install
popd
}

### PYDIO ###
_build_pydio() {
local VERSION="6.0.7"
local FOLDER="pydio-core-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/ajaxplorer/files/pydio/stable-channel/${VERSION}/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
# Change default path for php cli
sed -e "s|default=.php.|default=\"/mnt/DroboFS/Shares/DroboApps/apache2/bin/php\"|g" -i "plugins/core.ajaxplorer/manifest.xml"
# Change default path for imagemagick convert
sed -e "s|default=./usr/bin/convert.|default=\"/mnt/DroboFS/Shares/DroboApps/pydio/libexec/convert\"|g" -i "plugins/editor.imagick/manifest.xml"
mkdir -p "${DEST}/www"
cp -vfaR . "${DEST}/www"
popd
}

_build() {
  _build_imagemagick
  _build_pydio
  _package
}
