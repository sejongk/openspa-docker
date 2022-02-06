#!/bin/bash
TARGET_OS=$1
TARGET_ARCH=$2
IMAGE_NAME=$3
IMAGE_VER=$4

echo "Target platform: $TARGET_OS/$TARGET_ARCH"

cd openspa/cmd

# build openspa-client for target plaform
echo "Building openspa-client binary..."
cd openspa-client
go get -u ./...
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o ../../../openspa-client
cd ..
echo "Successfully builded openspa-client binary"

# build openspa-tools for target plaform
echo "Building openspa-tools binary..."
cd openspa-tools
go get -u ./...
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o ../../../openspa-tools
cd ..
echo "Successfully builded openspa-tools binary"

cd ../../

# build image
docker build --tag $IMAGE_NAME:$IMAGE_VER --platform $TARGET_ARCH -f Dockerfile-client .
