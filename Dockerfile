FROM ruby:2.6.3

RUN gem install bundler -v 2.0.2

WORKDIR /usr/src/app

COPY . .
RUN bundle install
RUN rake compile

CMD ["rake"]