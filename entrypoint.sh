#!/bin/bash

set -e

rm -f /studying_mate/tmp/pids/server.pid

# production環境の場合のみJSとCSSをビルド

if [ "$RAILS_ENV" = "production" ]; then
bundle exec rails assets:clobber
bundle exec rails assets:precompile
bundle exec rails db:migrate
fi

exec "$@"
