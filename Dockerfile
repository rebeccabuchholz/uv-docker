FROM python:3.12-slim as base

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

FROM base as dev

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen --no-install-project

COPY src /src

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen

ENV PYTHONPATH=$APP_DIR

RUN chown -R "$USER":"$USER" $APP_DIR

USER $USER

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--reload"]


# ==================== Prod stage ===================================

FROM base as prod

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

COPY src $APP_DIR/src

RUN --mount=type=cache,target=/home/$USER/.cache/uv \
    uv sync --frozen --no-dev

ENV PYTHONPATH=$APP_DIR

RUN chown -R "$USER":"$USER" $APP_DIR

USER $USER

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0"]