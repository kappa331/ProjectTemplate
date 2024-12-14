ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}

ARG RAILS_APP_NAME

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /${RAILS_APP_NAME}
WORKDIR /${RAILS_APP_NAME}
ADD docker/rails/Gemfile /${RAILS_APP_NAME}/Gemfile
ADD docker/rails/Gemfile.lock /${RAILS_APP_NAME}/Gemfile.lock
RUN bundle install
ADD ${RAILS_APP_NAME} /${RAILS_APP_NAME}