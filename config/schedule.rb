# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# 環境変数をうまい感じにやってくれる
ENV.each { |k, v| env(k, v) }

# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所
set :output, error: 'log/crontab_error.log', standard: 'log/crontab.log'
set :environment, :development

#定期実行したい処理を記入
every 1.minute do
  rake 'team_state:update_team_state'
end

# Learn more: http://github.com/javan/whenever
