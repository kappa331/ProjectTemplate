#! /bin/bash

mkdir_with_confirm() {
  if [ -z "$1" ]; then
    echo "config.shでフォルダ名が定義されていません"
  else
    if [ ! -d "$1" ]; then
      mkdir "$1"
      echo "'$1'フォルダを作成しました"
    else
      echo "'$1'フォルダはすでに存在します"
    fi
  fi
}

# configを読み込む
source config.sh

# プロジェクトフォルダを作成する
mkdir_with_confirm "../$PROJECT_NAME"

# dockerフォルダを作成する
mkdir_with_confirm "../$PROJECT_NAME/docker"

# railsフォルダを作成する
mkdir_with_confirm "../$PROJECT_NAME/docker/rails"

# postgresqlフォルダを作成する
mkdir_with_confirm "../$PROJECT_NAME/docker/postgresql"

# .envを生成する
envsubst < .env > "../$PROJECT_NAME/.env"

# Dockerfileをコピーする
cp Dockerfile "../$PROJECT_NAME/docker/rails/Dockerfile"

# docker-compose.ymlをコピーする
cp docker-compose.yml "../$PROJECT_NAME/docker-compose.yml"

# Gemfileを生成する
envsubst < Gemfile > "../$PROJECT_NAME/docker/rails/Gemfile"

# Gemfile.lockをコピーする
cp Gemfile.lock "../$PROJECT_NAME/docker/rails/Gemfile.lock"

# 現在位置の移動
cd ../$PROJECT_NAME

# # Railsアプリの雛形を生成する
docker-compose run web rails new "./$RAILS_APP_NAME" --force --database=postgresql

# # 新たなGemfileが作成されたので、イメージを再ビルドする
docker-compose build

# # docker/rails/database_template.ymlからdatabase.ymlを生成する
# envsubst < docker/rails/database_template.yml > database.yml

# # 変数を初期化する
# unset $RAILS_APP_NAME
