FROM ruby:3.2.2
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim

# Install yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn \
  && apt-get install -y cron

RUN mkdir /studying_mate2
WORKDIR /studying_mate2
RUN gem install bundler
COPY Gemfile Gemfile.lock /studying_mate2/
RUN bundle install
RUN service cron start
COPY . /studying_mate2
RUN yarn install --frozen-lockfile
RUN bundle exec whenever --update-crontab 
# entrypoint.shをコンテナ内の/usr/binにコピーし、実行権限を与える
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# ENTRYPOINTとCMDを統合
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
