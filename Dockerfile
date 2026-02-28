# syntax=docker/dockerfile:1.7
FROM python:3.12-slim

# Install curl for uv installer
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -Ls https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /app

# Copy dependency manifests first (better layer caching)
COPY pyproject.toml uv.lock* /app/

# Create venv + install deps (uses uv.lock if present)
RUN uv sync --frozen || uv sync

# Copy the bot source
COPY bot.py /app/bot.py

# Run
CMD ["uv", "run", "bot.py"]
