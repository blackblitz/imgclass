FROM python:3.14.6-slim-trixie AS base
COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /usr/local/bin
WORKDIR /app

ARG NO_DEV=true
ENV RUFF_NO_CACHE=true UV_NO_DEV=$NO_DEV UV_NO_SYNC=true

COPY . .
RUN uv sync --frozen

RUN useradd -m -u 1000 app
RUN if [ $NO_DEV = false ]; then \
        apt-get update && apt-get install -y git helix && \
        chown -R app:app /app; \
    fi
USER app

CMD ["uv", "run", "imgclass"]
