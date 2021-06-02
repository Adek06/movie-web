FROM ruby:2.7.0

# if you live in china
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /myapp

COPY . .

RUN bundle install

RUN rails db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
