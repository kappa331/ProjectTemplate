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

# railsアプリフォルダを作成する
mkdir_with_confirm "../$PROJECT_NAME/$RAILS_APP_NAME"

# .envを生成する
envsubst < .env > "../$PROJECT_NAME/.env"

# Dockerfileをコピーする
cp Dockerfile "../$PROJECT_NAME/docker/rails/Dockerfile"

# docker-compose.ymlをコピーする
cp docker-compose.yml "../$PROJECT_NAME/docker-compose.yml"

# Gemfileを生成する
envsubst < Gemfile > "../$PROJECT_NAME/$RAILS_APP_NAME/Gemfile"

# Gemfile.lockをコピーする
cp Gemfile.lock "../$PROJECT_NAME/$RAILS_APP_NAME/Gemfile.lock"

# 現在位置の移動
cd ../$PROJECT_NAME

# Railsアプリの雛形を生成する
docker-compose run web rails new . --force --database=postgresql

# 新たなGemfileが作成されたので、イメージを再ビルドする
docker-compose build

# 現在位置の移動
cd ../setup

# database.ymlを置換する
cp database.yml "../$PROJECT_NAME/$RAILS_APP_NAME/config/database.yml"

# 現在位置の移動
cd ../$PROJECT_NAME

# railsを起動する
docker-compose up -d

# データベースを生成する
docker-compose run web rake db:create