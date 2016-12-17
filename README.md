# Serfnode
Decentralized Service Discovery in Distributed System of Micro Services

## Usage
1. Install Docker
2. Build docker image from source ```$ docker build -t swapnilmg/serfnode .```
3. Source rc file ```$ . .rcSerfnode```
4. Start cluster of 5 serfnodes ```$ serf-start-cluster 5```
5. Enter in bash shell of serfnode4 ```$ docker exec -i -t serfnode4 /bin/bash```
6. Check Service discovery ```root@serfnode4:/# serf members```
7. Access primary serfnode webserver ```root@serfnode4:/# curl http://172.17.0.99```
8. Open new terminal and force stop serfnode0 ```$ docker stop serfnode0```
9. Check Service dicovery and status of serfnode0 from serfnode4 ```root@serfnode4:/# serf members```
10. Access new primary serfnode webserver ```root@serfnode4:/# curl http://172.17.0.99```
