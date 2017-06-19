FROM phusion/baseimage:0.9.22
MAINTAINER Muhammad Kaisar Arkhan <yuki@coala.io>

ENV DEBIAN_FRONTEND=noninteractive TERM=dumb

# Use the init system
CMD /sbin/my_init

# Install planet-venus and lighttpd
RUN apt-get update && \
    apt-get install -y --no-install-recommends planet-venus lighttpd

# Add update script
ADD update-page.sh /usr/bin/update-page

# Add lighttpd service
RUN mkdir -p /etc/service/lighttpd
ADD sv/lighttpd.sh /etc/service/lighttpd/run

# Add update-page one-shot
ADD one-shot/update-page.sh /etc/my_init.d/update-page.sh

# Add crontab
ADD crontab /etc/crontab

# Grant execution rights to scripts and services
RUN chmod +x /usr/bin/update-page && \
    chmod +x /etc/service/lighttpd/run && \
    chmod +x /etc/my_init.d/update-page.sh

# Use config file for lighttpd
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

# Create a basic planet
RUN planet --create planet

# Make planet folder into a volume
VOLUME /planet

# Expose port 80
EXPOSE 80

# Clean unneeded files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
