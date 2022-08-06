#/bin/bash

docker run -d \
	-p 53:53 \
	-p 8300:8300 \
	-p 8400:8400 \
	-p 8500:8500 \
	-e SERVICE_TAGS="consul servers" \
	progrium/consul:latest -server -ui-dir /ui -data-dir /tmp/consul -bootstrap-expect 1

# https://hub.docker.com/r/progrium/consul
