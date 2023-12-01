FROM ruby:3.2.2-alpine

RUN apk -U upgrade
RUN  apk --no-cache -t build-dependencies add \
    bash \
    build-base \
    git \
    vim \
    linux-headers \
    postgresql-dev \
    gcompat

RUN apk add --no-cache tini openrc

RUN apk add --update --no-cache \
    ruby-dev \
    file \
    openjdk8-jre-base \
    tzdata \
    postgresql-libs \
    glib \
    vips \
    imagemagick

# set production envs
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /app
WORKDIR /app
RUN gem install bundler -v 2.4.17
COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoints/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# ADD ./config/application.sample.yml /nbg_broadcaster_service/config/application.yml

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
