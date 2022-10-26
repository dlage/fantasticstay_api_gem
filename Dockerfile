FROM ruby:3.0

WORKDIR /usr/src/app

COPY Gemfile .
COPY Gemfile.lock .
COPY fantasticstay_api.gemspec .
COPY lib/fantasticstay_api/version.rb lib/fantasticstay_api/version.rb

RUN bundle install

COPY . .
