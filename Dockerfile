FROM ubuntu:14.04

COPY . /opt/xtratum

RUN dpkg --add-architecture i386 && apt-get update

RUN apt-get install -y \
	gcc-multilib \
	make \
	libncurses5-dev \
	binutils \
	libxml2-dev:i386 \
	makeself

CMD [ "bash" ]
