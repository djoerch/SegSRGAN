#!/usr/bin/env bash

cmd="docker"
args=()
args+=(build)
args+=(--build-arg username=$(id -un))
args+=(--build-arg userid=$(id -u))
args+=(-t segsrgan)
args+=(-f Dockerfile)
args+=(.)

${cmd} ${args[@]}
