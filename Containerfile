FROM python:3.14.6-slim-trixie AS base
COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /usr/local/bin
RUN useradd -m -u 1000 app
USER app
WORKDIR /usr/local/app
ENTRYPOINT ["uv", "run"]

FROM base AS dev
EXPOSE 2718
CMD ["marimo", "edit", "--host=0.0.0.0"]

FROM base AS prod
COPY pyproject.toml uv.lock .
RUN uv sync --frozen --no-dev
COPY . .
ENTRYPOINT ["python"]
