#!/bin/zsh

function build() {
    echo "building..."
    xcodebuild -verbose -workspace "The iOS Things.xcworkspace" -scheme Periphery -arch arm64 -sdk iphoneos > build-log.txt 2>&1
}

function export_log() {
    echo "analyzing..."
    sed -n '/\* Analyzing\.\.\./,/\* Seeing false positives\?/p' build-log.txt >> analyze-log.txt
}

build
export_log