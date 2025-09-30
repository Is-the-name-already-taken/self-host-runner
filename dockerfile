FROM debian:bookworm

WORKDIR /app
VOLUME /data

ARG VERSION
ARG HASH
ARG ORGANIZATION
ARG TOKEN
ENV VERSION=${VERSION}
ENV HASH=${HASH}
ENV ORGANIZATION=${ORGANIZATION}
ENV TOKEN=${TOKEN}

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN apt update && apt install -y --no-install-recommends \
    curl \
    git \
    tar \
    ca-certificates \
    perl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir actions-runner
WORKDIR /app/actions-runner

RUN curl -o actions-runner-linux-x64-${VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz
# RUN echo "${HASH}  actions-runner-linux-x64-${VERSION}.tar.gz" | shasum -a 256 -c <- Optional
RUN tar xzf ./actions-runner-linux-x64-${VERSION}.tar.gz

WORKDIR /app

CMD ["./entrypoint.sh", "${ORGANIZATION}", "${TOKEN}"]