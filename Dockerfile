# Container image that runs your code
FROM alpine:3.13

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

ARG TERRASCAN_VERSION=1.15.2
ARG CLI_VERSION=1.0.49
#RUN apk update && apk add --upgrade --no-cache ca-certificates curl jq git && \
#  curl -s https://www.tenable.com/downloads/api/v2/pages/cloud-security/files/accurics-cli_${CLI_VERSION}_linux_x86_64.tar.gz -o /usr/bin/accurics && \  
#  chmod 711 /entrypoint.sh /usr/bin/accurics

RUN apk update && apk add --upgrade --no-cache ca-certificates curl jq git && \
  curl -s https://www.tenable.com/downloads/api/v2/pages/cloud-security/files/accurics-cli_${CLI_VERSION}_linux_x86_64.tar.gz -o /tmp/accurics.tar.gz && \
  tar -xzvf /tmp/accurics.tar.gz -C /usr/bin/ && \
  chmod 711 /entrypoint.sh /usr/bin/accurics && \
  rm /tmp/accurics.tar.gz

  
RUN curl --location https://github.com/accurics/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz -o terrascan.tar.gz && \
    tar xvfz terrascan.tar.gz && \
    rm -f terrascan.tar.gz && \
    mv terrascan /usr/bin/ && \
    terrascan version

# Github clone by ssh compatibility    
RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

