FROM node:26-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @opencode/cli

RUN usermod -l opencode -d /home/opencode -m node \
    && groupmod -n opencode node

RUN mkdir -p /workspace /home/opencode/.config /home/opencode/.config/opencode \
    && chown -R opencode:opencode /workspace /home/opencode

USER opencode
WORKDIR /workspace

ENTRYPOINT ["opencode"]