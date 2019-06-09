FROM ruby:alpine

RUN apk add --no-cache build-base

WORKDIR /app
ADD . /app

RUN gem install bundler
RUN bundle config --global silence_root_warning 1
RUN bundle install --jobs 4 --without=development test

ENV PORT 9292
EXPOSE 9292

CMD ["puma", "-e", "production"]
