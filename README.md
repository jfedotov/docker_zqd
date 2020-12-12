# docker_zqd
LIMITATION:
it’s not possible for remote clients to import packet capture data (pcap files) directly to a remote zqd! 
However we can use the zapi command line tool on our VM to access this zqd directly via localhost.
Any packet captures you wish to access remotely will need to have been staged at the remote location.

Pcap location is /zqd_app/pcap_store/
Space location is /zqd_app/spaces/
