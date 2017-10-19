# Dockerfile to create a nodeclub image
FROM ubuntu:14.04
MAINTAINER sam.hu "guiqi.hu@gmail.com"

RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates
# RUN mkdir /nodejs && curl https://nodejs.org/dist/v0.10.40/node-v0.10.40-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
RUN mkdir /nodejs && curl https://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH $PATH:/nodejs/bin

# Install Git
RUN apt-get install git

# Downlaod Nodeclub
RUN git clone https://github.com/huguiqi/nodeclub.git /opt/nodejs

# RUN mkdir -p /opt/nodejs
ADD . /opt/nodejs
WORKDIR /opt/nodejs

# Install the dependencies modules
RUN npm install

# Make Build
RUN make build

# Make Test
# RUN make test

# Expose environment variables
# ENV MONGO_CARROT_ADDR **LinkMe**
# ENV MONGO_CARROT_PORT **LinkMe**
# ENV MONGO_CARROT_NAME admin
# ENV MONGO_CARROT_USER **ChangeMe**
# ENV MONGO_CARROT_PASS **ChangeMe**

VOLUME ["/data/db"]

# Install MongoDB
# ADD sources.list /etc/apt/
RUN apt-get update
# Install MongoDB Following the Instructions at MongoDB Docs
# Ref: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
# Add the package verification key
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
# Add MongoDB to the repository sources list
RUN echo 'deb http://repo.mongodb.org/apt/ubuntu '$(lsb_release -sc)'/mongodb-org/3.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
# Update the repository sources list once more
RUN apt-get update
# Install MongoDB package (.deb)
RUN apt-get install -y mongodb-org
# Create the default data directory
# RUN mkdir -p /data/db

# Install Redis
RUN apt-get -y install redis-server

# Install supervisor
RUN apt-get install -y supervisor

ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Node Redis MongoDB
EXPOSE 3000 6379 27017 28017

CMD ["/bin/bash", "/start.sh"]

#CMD ["/usr/bin/mongod", "--port 27017", "--dbpath /data/db"]
#EXPOSE 3000
#ENTRYPOINT ["node", "app.js"]