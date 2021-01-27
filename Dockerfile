FROM ubuntu:18.04

ENV LSB_RELEASE=bionic
ENV CLOUD_SDK_REPO=cloud-sdk-bionic
# CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
#     echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get update -y && apt-get install google-cloud-sdk -y
RUN apt-get update -y && apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    gnupg-agent \
    software-properties-common -y && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $LSB_RELEASE stable" && \
    apt-get update -y && \
    apt-get install docker-ce docker-ce-cli containerd.io -y

RUN echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

RUN useradd --home-dir /app -s /bin/bash -r -U -u 1000 -G root ubuntu && usermod -aG sudo ubuntu && usermod -aG docker ubuntu

RUN mkdir /app

WORKDIR /app

ADD .docker /app/.docker

RUN chown -R 1000 /app

USER ubuntu

ENTRYPOINT [ "gcloud" ]
