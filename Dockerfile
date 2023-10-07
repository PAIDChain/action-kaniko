FROM alpine as certs

RUN apk --update add ca-certificates

COPY jq-linux64 /jq
RUN chmod +x /jq

COPY reg-linux-386 /reg
RUN chmod +x /reg

COPY crane.tar.gz /crane.tar.gz
RUN mkdir -p /kaniko && \
    tar -xvzf /crane.tar.gz crane -C /kaniko

FROM gcr.io/kaniko-project/executor:v1.9.1-debug

SHELL ["/busybox/sh", "-c"]

# RUN wget -O /kaniko/jq \
#     https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
#     chmod +x /kaniko/jq && \
#     wget -O /kaniko/reg \
#     https://github.com/genuinetools/reg/releases/download/v0.16.1/reg-linux-386 && \
#     chmod +x /kaniko/reg && \

#     wget -O /crane.tar.gz \ 
#     https://github.com/google/go-containerregistry/releases/download/v0.8.0/go-containerregistry_Linux_x86_64.tar.gz && \
#     tar -xvzf /crane.tar.gz crane -C /kaniko && \
#     rm /crane.tar.gz

COPY entrypoint.sh /

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=certs /jq /usr/local/bin/jq
COPY --from=certs /reg /usr/local/bin/reg
COPY --from=certs /kaniko /kaniko

ENTRYPOINT ["/entrypoint.sh"]

# Command to build and push, NOTE: Please increment the version before build
# docker build --no-cache --platform=linux/amd64 -t 806608933540.dkr.ecr.ap-southeast-1.amazonaws.com/actions-kaniko:v1.16.0-debug-cicd.0 .
# docker push 806608933540.dkr.ecr.ap-southeast-1.amazonaws.com/actions-runner:v1.16.0-debug-cicd.0

# docker tag 806608933540.dkr.ecr.ap-southeast-1.amazonaws.com/actions-runner:v1.16.0-debug-cicd.0 668583736615.dkr.ecr.ap-southeast-1.amazonaws.com/actions-runner:v1.16.0-debug-cicd.0
# docker push 668583736615.dkr.ecr.ap-southeast-1.amazonaws.com/actions-runner:v1.16.0-debug-cicd.0
