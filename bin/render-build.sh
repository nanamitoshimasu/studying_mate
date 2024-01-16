#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
yarn build # jsファイルをesbuildでバンドルしているため
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails assets:precompile
