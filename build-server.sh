#!/bin/bash
TARGET_OS=$1
TARGET_ARCH=$2
IMAGE_NAME=$3
IMAGE_VER=$4

echo "Target platform: $TARGET_OS/$TARGET_ARCH"

mkdir -p es

cd openspa/cmd

# build openspa-server for target plaform
echo "Building openspa-server binary..."
cd openspa-server
go get -u ./...
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o ../../../openspa-server
cd ..
echo "Successfully builded openspa-server binary"

cd ../../

# set up extension scripts
cp openspa-extension-scripts/user_directory_service/user_directory_service.py es/
cp openspa-extension-scripts/authorization/authorization.py es/
cp openspa-extension-scripts/firewalls/iptables/rule_*.py es/
mkdir -p es/public_keys
echo "Successfully set up extension scripts"

# build image
docker build --tag $IMAGE_NAME:$IMAGE_VER --platform $TARGET_ARCH -f Dockerfile-server .
