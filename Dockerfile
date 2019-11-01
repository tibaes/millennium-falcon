FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

LABEL maintainer "JUNTO SEGUROS <squadanalytics@juntoseguros.com>"

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    openssh-server \
    apt-utils \
    locales \
    curl \
    wget \
    git \
    less \
    vim \
    nano \
    fish \
    iputils-ping \
    docker.io \
    python3 \
    python3-dev \
    python3-distutils && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    fontconfig \
    fonts-dejavu \
    fonts-liberation \
    ttf-mscorefonts-installer \
    fonts-firacode && \
    rm -rf /var/lib/apt/lists/* && \
    fc-cache -f -v && \
    rm -rf ~/.cache/matplotlib

RUN curl https://bootstrap.pypa.io/get-pip.py -o /root/get-pip.py && \
    python3 /root/get-pip.py && \
    rm /root/get-pip.py

COPY requirements.txt /root/
RUN export AIRFLOW_GPL_UNIDECODE=yes; \
    pip install -r /root/requirements.txt

RUN mkdir /playground
WORKDIR /playground
ENV PYTHONPATH /playground

RUN mkdir /root/.ssh/
COPY authorized_keys /root/.ssh/
RUN chmod -R 600 /root/.ssh

RUN mkdir /root/.aws
COPY aws/config /root/.aws/
COPY aws/credentials /root/.aws/

CMD bash
EXPOSE 8888
EXPOSE 22