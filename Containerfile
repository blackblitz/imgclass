FROM python:3.14.6-slim-trixie AS base
COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /usr/local/bin
WORKDIR /app

COPY . .
RUN uv sync --frozen

RUN useradd -m -u 1000 app
USER app

FROM base AS dev
EXPOSE 2718
CMD ["uv", "run", "marimo", "edit", "--host=0.0.0.0"]

FROM base AS prod
CMD ["uv", "run", "imgclass"]
