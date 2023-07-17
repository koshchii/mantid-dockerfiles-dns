#!/bin/bash

ORG="mantidproject"
VERSION="OK"

BUILD_LOG_DIR="build_logs"

function build_image {
  DOCKERFILE=$1
  OS=$2
  VERSION=$3

  IMAGE="mantid-development-${OS}"
  TAG="${VERSION}"

  echo "Building ${ORG}${IMAGE}:${TAG} from ${DOCKERFILE}"

  docker build \
    --file=${DOCKERFILE} \
    --build-arg DEV_PACKAGE_VERSION=${VERSION} \
    --tag=${ORG}/${IMAGE}:${TAG} \
    . | tee "${BUILD_LOG_DIR}/${IMAGE}_${TAG}.log"

  echo
}

mkdir -p ${BUILD_LOG_DIR}

build_image UbuntuFocalConda.Dockerfile ubuntuconda ${VERSION}
