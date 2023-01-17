FROM ruby:2.5.5
RUN apt-get update && apt-get install nodejs npm -y
RUN npm install -g yarn  
RUN gem install rails bundler
WORKDIR /app
RUN rails new . 
RUN bundle install
RUN bundle update
