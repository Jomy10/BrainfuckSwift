#!/usr/bin/env zsh

# Build for macos
swift build --configuration release
# Build for linux
docker run -v "$PWD:$PWD/build" -w "$PWD/build" swift:latest swift build --configuration release
