```shell
docker run --rm -it \
  -p 8000:8000 \
  -p 8433:8433 \
  -p 8002:8001 \
  -e 'KONG_DATABASE=postgres' \
  -e 'KONG_PG_HOST=sneck-iot-dev.cotiatmbriub.ap-northeast-2.rds.amazonaws.com' \
  -e 'KONG_PG_USER=sneck' \
  -e 'KONG_PG_PASSWORD=db2sneck.io!' \
  -e 'KONG_PG_DATABASE=kong2' \
  sneck/kong
```