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

docker pull library/fedora:latest
FEDORA_VERSION=$(docker run --rm library/fedora:latest sh -c "cat /etc/os-release | grep VERSION_ID= | cut -d= -f2")

if [ -z "${FEDORA_VERSION}" ]; then
  echo "Unable to determine the latest version of Fedora"
  exit -1
fi

docker image rm citymega/fedora:latest
docker build --build-arg IMAGE_VERSION=${FEDORA_VERSION} --build-arg \
 BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t citymega/fedora:latest -f "${SCRIPTDIR}/Dockerfile" "${SCRIPTDIR}"

retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Build Error"
  exit $retVal
fi

docker image tag citymega/fedora:latest citymega/fedora:${FEDORA_VERSION}
docker push citymega/fedora:${FEDORA_VERSION}
docker push citymega/fedora:latest
