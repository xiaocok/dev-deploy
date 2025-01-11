
docker run -d -p 5000:5000 --restart=always --name registry registry:2.8.3

docker run -d -p 8081:80 --name registry-ui -e REGISTRY_URL=http://mac-mini:5000 joxit/docker-registry-ui:latest

docker run -d -p 5001:8080 --name registry-web --link registry -e REGISTRY_URL=http://registry:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web

