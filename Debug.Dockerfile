FROM ruby:2.6.3

RUN gem install bundler -v 2.0.2

WORKDIR /usr/src/app

COPY Gemfile silicium.gemspec ./
COPY lib/silicium ./lib/silicium
RUN bundle install

RUN gem install ruby-debug-ide
RUN gem install debase

COPY . .
RUN rake compile

EXPOSE 1234
WORKDIR /usr/src/app/test
CMD rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- matrix_test.rb