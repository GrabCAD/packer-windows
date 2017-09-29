#!/bin/bash -x

ARTIFACTORY_URL="https://artifactory4.grabcad.net/artifactory/vagrant-local"
ARTIFACTORY_USERNAME="<FIXME>"
ARTIFACTORY_PASSWORD="<FIXME>"

DEFAULT_BUILDTYPE="virtualbox"
DEFAULT_BOX_VERSION="3.1.0"

function die() {
  echo $*
  exit 1
}

function upload() {
  basis=${1:-windows_2012_r2}
  buildtype=${2:-$DEFAULT_BUILDTYPE}
  ver=${3:-$DEFAULT_BOX_VERSION}

  fname=${basis}_${buildtype}.box

  md5=`md5sum $fname | cut -c -32`
  sha1=`sha1sum $fname | cut -c -40`

  curl \
      -u "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" \
      -T $fname \
      -H "X-Checksum-Md5: $md5" \
      -H "X-Checksum-Sha1: $sha1" \
      "$ARTIFACTORY_URL/GrabCAD/${basis}_${buildtype}_${ver}.box;box_name=GrabCAD%2F$basis;box_provider=${buildtype};box_version=$ver"
  [ $? -eq 0 ] || die "Upload failed for: $fname"
}

#upload windows_7
#upload windows_81
#upload windows_10
#upload windows_2012
upload windows_2012_r2
