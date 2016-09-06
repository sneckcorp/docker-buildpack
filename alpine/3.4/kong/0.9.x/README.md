```shell
docker run -d --name kong-database \
                -p 5432:5432 \
                -e "POSTGRES_USER=kong" \
                -e "POSTGRES_DB=kong" \
                -e "POSTGRES_PASSWORD=kong" \
                postgres:9.4
```

```shell
docker run -d --name kong \
  --link kong-database \
  -p 8000:8000 \
  -p 8433:8433 \
  -p 8002:8001 \
  -e 'KONG_DATABASE=postgres' \
  -e 'KONG_PG_HOST=kong-database' \
  -e 'KONG_PG_USER=kong' \
  -e 'KONG_PG_PASSWORD=kong' \
  -e 'KONG_PG_DATABASE=kong' \
  sneck/kong
```
