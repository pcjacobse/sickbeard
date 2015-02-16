FROM phusion/baseimage:0.9.16
MAINTAINER pcjacobse <pcjacobse@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 1000 nobody
RUN usermod -g 100 nobody

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN apt-get update -q

# Install Dependencies
RUN apt-get install -qy python python-cheetah ca-certificates wget unrar

# Install SickBeard
RUN mkdir /opt/sickbeard
RUN wget https://github.com/pcjacobse/Sick-Beard/archive/master.tar.gz -O /tmp/sickbeard.tar.gz
RUN tar -C /opt/sickbeard -xvf /tmp/sickbeard.tar.gz --strip-components 1
RUN chown nobody:users /opt/sickbeard

EXPOSE 8081

# SickBeard Configuration
VOLUME /config

# Downloads directory
VOLUME /downloads

# TV directory
VOLUME /tv

# Add Sickbeard to runit
RUN mkdir /etc/service/sickbeard
ADD sickbeard.sh /etc/service/sickbeard/run
RUN chmod +x /etc/service/sickbeard/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
