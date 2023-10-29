FROM citymega/httpd:latest

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL maintainer="citymega" \
      name="Apache HTTP Server with CAS" \
      version="$IMAGE_VERSION" \
      build-date="$BUILD_DATE"

RUN dnf -y --disablerepo="*" --enablerepo="updates,fedora" install mod_auth_cas && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    rm /etc/httpd/conf.d/ssl.conf

EXPOSE 80

CMD [ "/sbin/httpd", "-D", "FOREGROUND" ]
