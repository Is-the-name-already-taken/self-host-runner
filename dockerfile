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
COPY requirements.txt .

RUN apt update && apt install -y --no-install-recommends $(cat requirements.txt) \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m runner
RUN mkdir actions-runner && chown runner:runner /app/actions-runner
RUN mkdir -p /data && chown runner:runner /data

USER runner

WORKDIR /app/actions-runner

RUN curl -o actions-runner-linux-x64-${VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz
# RUN echo "${HASH}  actions-runner-linux-x64-${VERSION}.tar.gz" | shasum -a 256 -c <- Optional
RUN tar xzf ./actions-runner-linux-x64-${VERSION}.tar.gz

WORKDIR /app

CMD ["./entrypoint.sh", "${ORGANIZATION}", "${TOKEN}"]