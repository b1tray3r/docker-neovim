default:
    just --list

build: build-base build-go build-php

build-base:
    docker build --target base -t nvim-base .

build-go:
    docker build --target go -t nvim-go .

build-php:
    docker build --target php -t nvim-php .

run-base:
    docker run -it --rm -v $(pwd):/workspace nvim-base

run-go:
    docker run -it --rm -v $(pwd):/workspace nvim-go

run-php:
    docker run -it --rm -v $(pwd):/workspace nvim-php

# Run with clipboard support (requires X11)
run-base-x11:
    xhost +local:docker
    docker run -it --rm \
        -v $(pwd):/workspace \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        nvim-base

run-go-x11:
    xhost +local:docker
    docker run -it --rm \
        -v $(pwd):/workspace \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        nvim-go

run-php-x11:
    xhost +local:docker
    docker run -it --rm \
        -v $(pwd):/workspace \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        nvim-php

clean:
    docker rmi -f nvim-base nvim-go nvim-php
