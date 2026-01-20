FROM python:3.13-slim AS base

ENV USER=uv-user \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_PROJECT_ENVIRONMENT=/usr/local

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash $USER

COPY --from=ghcr.io/astral-sh/uv:0.7.15 /uv /uvx /bin/

ENV APP_DIR=/home/$USER
WORKDIR $APP_DIR

COPY pyproject.toml uv.lock* ./

# ======================== Dev stage =================================

FROM base AS dev

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --locked --no-install-project --color auto

COPY src /src

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --locked --color auto

ENV PYTHONPATH=$APP_DIR

RUN chown -R "$USER":"$USER" $APP_DIR

USER $USER

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--reload"]


# ==================== Prod stage ===================================

FROM base AS prod

# Compile Python source files to bytecode to improve startup time
#   (at the cost of increased installation time)
ENV UV_COMPILE_BYTECODE=1

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

COPY src $APP_DIR/src

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen --no-dev

ENV PYTHONPATH=$APP_DIR

RUN chown -R "$USER":"$USER" $APP_DIR

USER $USER

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0"]