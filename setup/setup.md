# 実行方法
```
./setup.sh
```

# 実行権限を付与する
```
chmod +x setup.sh
```

# docker-comopseのキャッシュ削除
```
docker builder prune -a
docker system prune -a
docker rmi $(docker images -f "dangling=true" -q)
docker volume rm $(docker volume ls -qf dangling=true)
docker rm $(docker ps -a -q)
docker system prune -a --volumes
```

docker-compose run web rails new . --force --database=postgresql
docker-compose build
# データベースの接続設定
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password:
  pool: 5

development:
  <<: *default
  database: myapp_development


test:
  <<: *default
  database: myapp_test

#
docker-compose up