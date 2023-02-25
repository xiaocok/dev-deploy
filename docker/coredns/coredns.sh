#!/bin/bash

docker run -d -p 53:53/tcp -p 53:53/udp -p 9153:9153 -v `pwd`/Corefile:/etc/coredns/Corefile --name coredns coredns/coredns:1.9.4 -conf /etc/coredns/Corefile

