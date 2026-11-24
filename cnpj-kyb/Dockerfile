FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# venv fora de /app, para o volume .:/app não esconder ela
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-install-project