FROM ruby:2.7.0-alpine
MAINTAINER me@akinyele

# set an environment variable to specify the Bundler version:
ENV BUNDLER_VERSION=2.1.2

# add the packages that we need to work with the application to the Dockerfile
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \ 
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-client \
      postgresql-dev \
      python \
      tzdata \
      yarn 

# install the appropriate bundler version
RUN gem install bundler -v 2.1.2

# set the working directory for the application on the container
WORKDIR /rails-app

# copy over your Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# set the configuration options for the nokogiri gem build
RUN bundle config build.nokogiri --use-system-libraries

# install the project gems
RUN bundle check || bundle install

# copy package.json and yarn.lock from the project directory on the host to the container
# uncomment this if you have Javascript in your project.
# COPY package.json yarn.lock ./

# install the required packages
# uncomment this if you have Javascript in your project.
# RUN yarn install --check-files

# use foreman
RUN gem install foreman

# copy over the rest of the application code and start the application with an entrypoint script
COPY . ./
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
