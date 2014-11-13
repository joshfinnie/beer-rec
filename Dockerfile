FROM    centos:centos6

RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN     yum install -y npm
RUN     npm install -g coffee-script

EXPOSE  1337
WORKDIR /code
CMD "npm install .; coffee /code/app/server.coffee"
