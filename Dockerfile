FROM ubuntu:14.04
MAINTAINER James Bishop <james.bishop@otechresources.com>

# Install required packages
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      ca-certificates \
      openssh-server \
      wget \
      apt-transport-https \
      vim \
      nano \
      patch

# Copy assets
COPY RELEASE /
COPY assets/ /assets/
RUN /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/srv/opt/gitlab", "/srv/log/gitlab", "/etc/hosts", "/etc/resolv.conf"]

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]
