# docker_zqd
https://hub.docker.com/r/jfedotov/zqd

**LIMITATION:**

it’s not possible for remote clients to import packet capture data (pcap files) directly to a remote zqd!

**Any packet captures you wish to access remotely will need to have been staged at the remote location.**

Directory for pcap files: /zqd_app/pcap_store/ Folder is mounted with local "pcap_store" directory. All pcap files must be uploaded into "pcap_store" directory. 

Space location is /zqd_app/spaces/ Folder is mounted with local "spaces" directory. All spaces will be created in "spaces" directory.

**How to use:**

    1. Start docker container with "docker-compose up -d" command.
    2. Zqd is running on port 5020. Use zq API client to connect to zqd: command line, python, brim etc.
    3. To stop docker container, use "docker-compose down" command.

**Example:**

Using zapi command line:

    1. Connect to zqd and create new space, instead of 10.1.1.1 use ip address of the server where Docker container is running:        
        zapi -h 10.1.1.1:5020 new myspace_test
        Output: myspace_test: space created
    2. Upload pcap to pcap_store directory on zqd server.
    3. Post pcap to zq:
        zapi -h 10.1.1.1:5020 -s myspace_test postpcap /zqd_app/pcap_store/eth0.pcap
        Output for successful post: 
        100.0% 13.39MB/13.39MB
        /zqd_app/pcap_store/eth0.pcap: pcap posted
    4. To find all sessions with destination port 5061, run:
        zapi -h 10.1.1.1:5020 -s myspace_test get -t id.resp_p=5061 _path="conn"
