FROM ubuntu:16.04

MAINTAINER Swapnil Gaikwad <swapnil.gaikwad@sjsu.edu>

#update Linux
RUN apt-get update -y

#install serf
RUN apt-get install -y unzip curl
RUN curl -Lso /tmp/serf.zip https://releases.hashicorp.com/serf/0.8.0/serf_0.8.0_linux_amd64.zip
RUN mkdir -p /usr/local/serfnode/bin
RUN unzip /tmp/serf.zip -d /usr/local/serfnode/bin
RUN ln -s /usr/local/serfnode/bin/serf /usr/local/bin/serf
RUN rm /tmp/serf.zip

#environemnt variables
ENV SERF_HOME /usr/local/serfnode

#add
ADD serfnode $SERF_HOME

EXPOSE 7373 7946
CMD $SERF_HOME/bin/startSerfAgent.sh