FROM gitpod/workspace-full-vnc

ENV FLUTTER_HOME=/home/gitpod/flutter \
    PATH=/usr/lib/dart/bin:$FLUTTER_HOME/bin:$PATH

USER root

RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && \
    apt-get -y install  build-essential dart libkrb5-dev gcc make jq && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

USER gitpod

RUN cd /home/gitpod \
    && FLUTTER_CHANNEL="beta" \
    && curl https://storage.googleapis.com/flutter_infra/releases/releases_linux.json > flutter_releases_linux.json \
    && base_url=`jq -r .base_url flutter_releases_linux.json` \
    && release_hash=`jq .current_release.$FLUTTER_CHANNEL flutter_releases_linux.json` \
    && release_archive=`jq -r ".releases[] | select(.hash == $release_hash) | .archive" flutter_releases_linux.json` \
    && rm flutter_releases_linux.json \
    && wget -O flutter_sdk.tar.xz $base_url/$release_archive \
    && tar -xvf flutter_sdk.tar.xz && rm flutter_sdk.tar.xz \
    && $FLUTTER_HOME/bin/flutter config --enable-web \
    && echo "export PATH=$FLUTTER_HOME/bin:\$PATH" >> .bashrc;
 
