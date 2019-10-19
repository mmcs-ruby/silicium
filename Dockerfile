FROM ruby:2.6.3

RUN gem install bundler -v 2.0.2

WORKDIR /usr/src/app

COPY Gemfile silicium.gemspec ./
COPY lib ./lib
RUN bundle install

COPY . .
RUN rake compile

CMD ["rake"]