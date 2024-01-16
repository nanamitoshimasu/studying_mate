FROM ruby:3.2.2

ENV TZ Asia/Tokyo

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim

RUN apt-get install -y cron

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

WORKDIR /studying_mate

COPY Gemfile Gemfile.lock /studying_mate/

RUN bundle install

COPY package.json yarn.lock /studying_mate/

RUN yarn install

RUN yarn add daisyui

COPY . /studying_mate/

RUN bundle exec whenever --update-crontab 
RUN service cron start

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["./bin/dev"]
