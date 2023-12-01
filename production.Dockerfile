FROM ruby:3.0.1-alpine

RUN apk -U upgrade
RUN  apk --no-cache -t build-dependencies add \
    bash \
    build-base \
    git \
    vim \
    linux-headers \
    postgresql-dev \
    gcompat

RUN apk add --no-cache tini openrc busybox-initscripts

RUN apk add --update --no-cache \
    ruby-dev \
    file \
    openjdk8-jre-base \
    tzdata \
    postgresql-libs \
    glib \
    vips \
    imagemagick

RUN apk add --update nodejs nodejs-npm
RUN npm install --global yarn    

# set production envs
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle install
RUN bundle exec rails webpacker:install
RUN bundle exec rake assets:precompile --trace

# Add a script to be executed every time the container starts.
COPY entrypoints/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN sidekiq &

# ADD ./config/application.sample.yml /nbg_broadcaster_service/config/application.yml

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
