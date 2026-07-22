FROM python:3.14.6-slim-trixie AS base
COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /usr/local/bin
WORKDIR /app
RUN useradd -m -u 1000 app

FROM base AS dev
COPY --from=ghcr.io/astral-sh/ruff:0.15.22 /ruff /usr/local/bin
COPY --from=ghcr.io/astral-sh/ty:0.0.61 /ty /usr/local/bin
RUN apt-get update && apt-get install -y git wget && \
    TEMP="$(mktemp)" && \
    wget -O "$TEMP" "https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb" && \
    dpkg -i "$TEMP" && \
    rm -f "$TEMP"
COPY . .
RUN uv sync --locked && chown -R app:app /app
USER app
CMD ["uv", "run", "imgclass"]

FROM base AS prod
COPY . .
RUN uv sync --locked --no-dev
USER app
CMD ["uv", "run", "imgclass"]
