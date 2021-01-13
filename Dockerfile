
FROM golang:1.14

ARG TARGETOS
ARG TARGETARCH

ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=${TARGETOS} \
  GOARCH=${TARGETARCH}

WORKDIR /go/src/github.com/xunholy/coredns/

RUN git clone https://github.com/xunholy/coredns.git . && \
  make

FROM debian:stable-slim

RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates

FROM scratch

COPY --from=0 /go/src/github.com/xunholy/coredns/coredns /cordns
COPY --from=1 /etc/ssl/certs /etc/ssl/certs
ADD coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]
