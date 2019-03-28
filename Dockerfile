FROM alpine:3.6
MAINTAINER Vlad <devvlad@gmail.com>
WORKDIR /
ENV HOME=/ \
    PATH=/google-cloud-sdk/bin:$PATH \
    CLOUDSDK_PYTHON_SITEPACKAGES=1 \
    BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

# Install required packages
# Install envsubst [better than using 'sed' for yaml substitutions]
RUN apk --update add ca-certificates wget python curl tar \
          jq git bash openssl $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# Install gcloud and kubectl
# kubectl will be available at /google-cloud-sdk/bin/kubectl
# This is added to $PATH
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && \
    unzip google-cloud-sdk.zip && \
    rm google-cloud-sdk.zip && \
    google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app kubectl alpha beta

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

# Install Helm plugins
RUN helm init --client-only
# Plugin is downloaded to /tmp, which must exist
RUN mkdir -p /tmp
RUN helm plugin install https://github.com/viglesiasce/helm-gcs.git
RUN helm plugin install https://github.com/databus23/helm-diff