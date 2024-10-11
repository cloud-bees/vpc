FROM ubuntu:22.04

# hadolint ignore=DL3008
RUN apt-get update && apt-get install wget curl ca-certificates unzip git git-lfs -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*
