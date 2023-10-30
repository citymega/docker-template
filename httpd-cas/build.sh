#!/bin/sh

PRG="$0"
while [ -h "$PRG" ] ; do
  ls=$(ls -ld "$PRG")
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG="$(dirname "$PRG")/$link"
  fi
done
SCRIPTDIR="$(dirname "$PRG")"

HTTPD_INFO=$(docker run --rm citymega/fedora:latest dnf -q --disablerepo="*" --enablerepo="updates" info httpd.x86_64)
HTTPD_VERSION=$(echo "$HTTPD_INFO" | egrep '^Version' | awk '{print $3}' | sed -e 's/[[:space:]]*$//')
HTTPD_RELEASE=$(echo "$HTTPD_INFO" | egrep '^Release' | awk '{print $3}')
HTTPD_FULL_VERSION=${HTTPD_VERSION}-${HTTPD_RELEASE}

if [ -z "${HTTPD_VERSION}" ]; then
  echo "Unable to determine the latest version of HTTPD"
  exit -1
fi

if [ -z "${HTTPD_RELEASE}" ]; then
  echo "Unable to determine the latest version of HTTPD"
  exit -1
fi

docker image rm citymega/httpd:cas
docker build --build-arg IMAGE_VERSION=${HTTPD_FULL_VERSION} --build-arg \
 BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t citymega/httpd:cas -f "${SCRIPTDIR}/Dockerfile" "${SCRIPTDIR}/.."

retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Build Error"
  exit $retVal
fi

docker image tag citymega/httpd:cas citymega/httpd:2.4-cas
docker image tag citymega/httpd:cas citymega/httpd:${HTTPD_VERSION}-cas
docker image tag citymega/httpd:cas citymega/httpd:${HTTPD_FULL_VERSION}-cas
docker push citymega/httpd:2.4-cas
docker push citymega/httpd:${HTTPD_VERSION}-cas
docker push citymega/httpd:${HTTPD_FULL_VERSION}-cas
