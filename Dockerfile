FROM ruby:3.0
MAINTAINER Vox Pupuli <voxpupuli@groups.io>

ENV RACK_ENV production

# Bundle first to keep cache
ADD ./Gemfile /app/Gemfile
ADD ./Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle --without test

# Rest of app
ADD . /app

EXPOSE 8080
LABEL docmeta.rubydoc=true
ENV DOCKERIZED=1

CMD bundle exec rake server:start
