FROM debian:bookworm

WORKDIR /app
VOLUME /data

ARG VERSION
ARG HASH
ARG HOST_UID
ARG HOST_GID
ENV VERSION=${VERSION}
ENV HASH=${HASH}
ENV HOST_UID=${HOST_UID}
ENV HOST_GID=${HOST_GID}

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
COPY requirements.txt .

RUN apt update && apt install -y --no-install-recommends $(cat requirements.txt) \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -s /bin/bash runner

RUN usermod -aG sudo runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir actions-runner && chown runner:runner /app/actions-runner
RUN mkdir -p /data && chown runner:runner /data

RUN mkdir -p /run/user/0/podman && \
    chown -R runner:runner /data /app/actions-runner

WORKDIR /app/actions-runner

RUN curl -o actions-runner-linux-x64-${VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz
# RUN echo "${HASH}  actions-runner-linux-x64-${VERSION}.tar.gz" | shasum -a 256 -c <- Optional
RUN tar xzf ./actions-runner-linux-x64-${VERSION}.tar.gz

USER runner

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]
