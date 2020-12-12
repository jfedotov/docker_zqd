FROM ubuntu
#make a working directory
RUN mkdir /zqd_app
WORKDIR /zqd_app
#add timezone ENV, needed for one of dependencies
ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#installing dependencies
RUN apt update && apt upgrade -y
RUN apt -y -f install git flex bison libpcap-dev libssl-dev python-dev python3-dev swig zlib1g-dev wget unzip
RUN apt -y autoremove
#installing zeek and zeek dependencies
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.32-0ubuntu5_amd64.deb && dpkg -i libc6_2.32-0ubuntu5_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/libbroker-dev_3.2.2-0_amd64.deb && dpkg -i libbroker-dev_3.2.2-0_amd64.deb
RUN wget http://ftp.de.debian.org/debian/pool/main/libm/libmaxminddb/libmaxminddb0_1.4.3-2_amd64.deb && dpkg -i libmaxminddb0_1.4.3-2_amd64.deb
RUN wget http://ftp.de.debian.org/debian/pool/main/libm/libmaxminddb/libmaxminddb-dev_1.4.3-2_amd64.deb && dpkg -i libmaxminddb-dev_1.4.3-2_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/zeek-core_3.2.2-0_amd64.deb && dpkg -i zeek-core_3.2.2-0_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/zeek-libcaf-dev_3.2.2-0_amd64.deb && dpkg -i zeek-libcaf-dev_3.2.2-0_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/zeek-core-dev_3.2.2-0_amd64.deb && dpkg -i zeek-core-dev_3.2.2-0_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/zeekctl_3.2.2-0_amd64.deb && dpkg -i zeekctl_3.2.2-0_amd64.deb
RUN wget https://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.10/amd64/zeek_3.2.2-0_amd64.deb && dpkg -i zeek_3.2.2-0_amd64.deb
#add zeek to PATH
ENV PATH /opt/zeek:$PATH
ENV PATH /opt/zeek/bin:$PATH
#copy zeekrunner file to run zeek and pcap support
COPY zeekrunner /opt/zeek/
#installing zq
RUN wget https://github.com/brimsec/zq/releases/download/v0.24.0/zq-v0.24.0.linux-amd64.zip && unzip zq-v0.24.0.linux-amd64.zip -d /usr/local/bin/
ENV PATH /usr/local/bin/zq-v0.24.0.linux-amd64:$PATH
#make directory for zq spaces and pcap_store
RUN mkdir spaces
RUN mkdir pcap_store
#expose zqd listen port
EXPOSE 9867
#start zqd 
CMD zqd listen -data /zqd_app/spaces -zeekrunner zeekrunner