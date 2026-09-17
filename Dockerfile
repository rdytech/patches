# Development container for working on the gem. The Ruby version can be
# overridden to reproduce any cell of the matrix in README.md:
#
#   docker compose build --build-arg RUBY_VERSION=3.1
ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}

WORKDIR /app/
COPY . /app/
RUN bundle install

CMD ["bundle", "exec", "rspec"]
