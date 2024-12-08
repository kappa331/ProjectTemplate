# 実行方法
```
$./setup.sh
```

# 実行権限を付与する
```
$chmod +x setup.sh
```

# docker-comopseのキャッシュ削除
```
docker builder prune -a
docker system prune -a
docker volume rm $(docker volume ls -qf dangling=true)
```