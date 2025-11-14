FROM ubuntu:24.04 AS builder-base

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    nodejs \
    npm \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && rm nvim-linux-x86_64.tar.gz

RUN npm install -g \
    dockerfile-language-server-nodejs \
    @microsoft/compose-language-service \
    yaml-language-server

FROM builder-base AS builder-base-final

RUN mkdir -p /root/.config/nvim

COPY init.lua /root/.config/nvim/init.lua

RUN nvim --headless -c 'quitall' 2>&1 || true

RUN nvim --headless -c 'TSInstallSync dockerfile' -c 'quitall' 2>&1 || true
RUN nvim --headless -c 'TSInstallSync yaml' -c 'quitall' 2>&1 || true

FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"
ENV LANG=de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    nodejs \
    npm \
    ca-certificates \
    locales \
    && sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder-base-final /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder-base-final /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder-base-final /usr/local/bin/docker-langserver /usr/local/bin/
COPY --from=builder-base-final /usr/local/bin/docker-compose-langserver /usr/local/bin/
COPY --from=builder-base-final /usr/local/bin/yaml-language-server /usr/local/bin/
COPY --from=builder-base-final /root/.config/nvim /root/.config/nvim
COPY --from=builder-base-final /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder-base-final /root/.local/state/nvim /root/.local/state/nvim

WORKDIR /workspace

CMD ["/bin/bash"]

FROM builder-base AS builder-go

ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"

RUN wget https://go.dev/dl/go1.25.4.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.25.4.linux-amd64.tar.gz \
    && rm go1.25.4.linux-amd64.tar.gz

RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    && go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest \
    && go install github.com/air-verse/air@latest \
    && go install github.com/rubenv/sql-migrate/...@latest

RUN mkdir -p /root/.config/nvim

COPY init.go.lua /root/.config/nvim/init.lua

RUN nvim --headless -c 'quitall' 2>&1 || true

RUN nvim --headless -c 'TSInstallSync go' -c 'quitall' 2>&1 || true
RUN nvim --headless -c 'TSInstallSync dockerfile' -c 'quitall' 2>&1 || true
RUN nvim --headless -c 'TSInstallSync yaml' -c 'quitall' 2>&1 || true

FROM ubuntu:24.04 AS go

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/nvim-linux-x86_64/bin:/usr/local/go/bin:/root/go/bin:${PATH}"
ENV LANG=de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    nodejs \
    npm \
    ca-certificates \
    locales \
    && sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder-go /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder-go /usr/local/go /usr/local/go
COPY --from=builder-go /root/go/bin /root/go/bin
COPY --from=builder-go /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder-go /usr/local/bin/docker-langserver /usr/local/bin/
COPY --from=builder-go /usr/local/bin/docker-compose-langserver /usr/local/bin/
COPY --from=builder-go /usr/local/bin/yaml-language-server /usr/local/bin/
COPY --from=builder-go /root/.config/nvim /root/.config/nvim
COPY --from=builder-go /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder-go /root/.local/state/nvim /root/.local/state/nvim

WORKDIR /workspace

CMD ["/bin/bash"]

FROM builder-base AS builder-php

RUN npm install -g intelephense

RUN mkdir -p /root/.config/nvim

COPY init.php.lua /root/.config/nvim/init.lua

RUN nvim --headless -c 'quitall' 2>&1 || true

RUN nvim --headless -c 'TSInstallSync php' -c 'quitall' 2>&1 || true
RUN nvim --headless -c 'TSInstallSync dockerfile' -c 'quitall' 2>&1 || true
RUN nvim --headless -c 'TSInstallSync yaml' -c 'quitall' 2>&1 || true

FROM ubuntu:24.04 AS php

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"
ENV LANG=de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    nodejs \
    npm \
    ca-certificates \
    locales \
    && sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder-php /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder-php /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder-php /usr/local/bin/intelephense /usr/local/bin/
COPY --from=builder-php /usr/local/bin/docker-langserver /usr/local/bin/
COPY --from=builder-php /usr/local/bin/docker-compose-langserver /usr/local/bin/
COPY --from=builder-php /usr/local/bin/yaml-language-server /usr/local/bin/
COPY --from=builder-php /root/.config/nvim /root/.config/nvim
COPY --from=builder-php /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder-php /root/.local/state/nvim /root/.local/state/nvim

WORKDIR /workspace

CMD ["/bin/bash"]
