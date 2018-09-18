FROM ruby:2.3

RUN touch ~/.gemrc && echo "gem: --no-ri --no-rdoc" >> ~/.gemrc

WORKDIR /app/
ADD . /app/
RUN bundle install

CMD bundle exec rake -T
