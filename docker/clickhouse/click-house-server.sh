# docker run -d --name clickhouse-server --ulimit nofile=262144:262144 -p 9000:9000 -p 8123:8123 --volume=$(pwd)/clickhouse-server:/etc/clickhouse-server --volume=$(pwd)/clickhouse:/var/lib/clickhouse yandex/clickhouse-server


docker run -d --name clickhouse-server --ulimit nofile=262144:262144 -p 9000:9000 -p 8123:8123 --volume=$(pwd)/clickhouse-server:/etc/clickhouse-server --volume=$(pwd)/clickhouse:/var/lib/clickhouse clickhouse/clickhouse-server:22.10
