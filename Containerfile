FROM python:3.14.6-slim-trixie AS base
COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /usr/local/bin
WORKDIR /app
COPY . .
CMD ["uv", "run", "imgclass"]

FROM base AS dev
COPY --from=ghcr.io/astral-sh/ruff:0.15.22 /ruff /usr/local/bin
COPY --from=ghcr.io/astral-sh/ty:0.0.61 /ty /usr/local/bin
RUN apt-get update && apt-get install -y git && uv sync --locked

FROM base AS prod
RUN uv sync --locked --no-dev && useradd -m -u 1000 app
USER app
