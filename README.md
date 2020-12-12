# docker_zqd
**LIMITATION:**
it’s not possible for remote clients to import packet capture data (pcap files) directly to a remote zqd!

**Any packet captures you wish to access remotely will need to have been staged at the remote location.**

Directory for pcap files: /zqd_app/pcap_store/ Folder's mounted with local "pcap_store" directory. All pcap files must be uploaded into "pcap_store" directory. 

Space location is /zqd_app/spaces/ Folder's mounted with local "spaces" directory. All spaces will be created in "spaces" directory.
