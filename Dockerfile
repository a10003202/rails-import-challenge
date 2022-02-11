#Image that we will be use
FROM phusion/passenger-ruby25
#Update repositories apt and add tzdata for used timezone
RUN mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bak
RUN apt update && apt install -y ca-certificates
RUN mv /etc/apt/sources.list.d.bak /etc/apt/sources.list.d
RUN apt-get update && \
    apt-get install -y tzdata && \
    apt-get install -y libfontconfig1 && \
    apt-get install -y libxrender1 && \
    apt-get install -y nodejs && \
    apt-get install -y npm && \
    apt-get install -y yarn && \
    apt-get install -y mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g yarn

#Set the app directory, "/home/app" is the default by the images
ENV APP_HOME /home/app
#Here is a reference to Home App directory on image
WORKDIR $APP_HOME

RUN bash -lc 'rvm install ruby-2.5.1'
RUN bash -lc 'rvm --default use ruby-2.5.1'

RUN gem install bundler -v 2.2.23
# Copy gem file first
COPY Gemfile Gemfile.lock ./
# Setup Gems
RUN bundle install
RUN chmod 777 -R /home/app

#open port 3000
EXPOSE 3000

#commando to run the imagen container
CMD ["/sbin/my_init"]