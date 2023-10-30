FROM citymega/fedora:latest

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL maintainer="citymega" \
      name="Apache HTTP Server" \
      version="$IMAGE_VERSION" \
      build-date="$BUILD_DATE"

RUN dnf -y --disablerepo="*" --enablerepo="updates,fedora" install httpd && \
    dnf clean all && \
    rm -rf /var/cache/dnf ; \
    rm -f /etc/httpd/conf.d/userdir.conf ; \
    sed -ri \
		-e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
		-e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
		/etc/httpd/conf/httpd.conf

EXPOSE 80

CMD [ "/sbin/httpd", "-D", "FOREGROUND" ]
