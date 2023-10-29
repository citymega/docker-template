FROM library/fedora:latest

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL maintainer="citymega" \
      name="Fedora" \
      version="$IMAGE_VERSION" \
      build-date="$BUILD_DATE"

RUN echo "fastestmirror=True" >>/etc/dnf/dnf.conf && \
    dnf -y update && \
    dnf clean all && \
    rm -rf /var/cache/dnf
