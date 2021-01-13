FROM ubuntu:20.10
#make a working directory
RUN mkdir /zqd_app
WORKDIR /zqd_app
#add timezone ENV, needed for one of dependencies
ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#installing dependencies
RUN apt update && apt upgrade -y
RUN apt -y -f install git flex bison libpcap-dev libssl-dev python-dev python3-dev swig zlib1g-dev wget unzip gnupg gnupg1 gnupg2
RUN apt -y autoremove
#installing zeek and zeek dependencies
RUN apt -y -f install curl
RUN echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/ /' | tee /etc/apt/sources.list.d/security:zeek.list
RUN curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/security_zeek.gpg
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y -f install zeek
#add zeek to PATH
ENV PATH /opt/zeek:$PATH
ENV PATH /opt/zeek/bin:$PATH
#copy zeekrunner file to run zeek and pcap support
COPY zeekrunner /opt/zeek/
#installing zq
RUN wget https://github.com/brimsec/zq/releases/download/v0.27.1/zq-v0.27.1.linux-amd64.zip && unzip zq-v0.27.1.linux-amd64.zip -d /usr/local/bin/
ENV PATH /usr/local/bin/zq-v0.27.1.linux-amd64:$PATH
#make directory for zq spaces and pcap_store
RUN mkdir spaces
RUN mkdir pcap_store
#expose zqd listen port
EXPOSE 9867
#start zqd 
CMD zqd listen -data /zqd_app/spaces -zeekrunner zeekrunner