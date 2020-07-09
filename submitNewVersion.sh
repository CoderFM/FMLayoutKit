#! /bin/bash
basePath=$(cd "$(dirname "$0")";pwd)
cd $basePath
pod repo push FMPodSpec FMLayoutKit.podspec --allow-warnings &&
pod trunk push FMLayoutKit.podspec --allow-warnings

