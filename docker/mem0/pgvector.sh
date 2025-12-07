docker run -d \
  --name postgres \
  --shm-size=128mb \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  ankane/pgvector:v0.5.1
