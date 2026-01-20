# uv-docker

<div>
    <a href="https://github.com/rebeccabuchholz/uv-docker/blob/main/LICENSE" target="_blank">
      <img alt="License" src="https://img.shields.io/pypi/l/websnap?color=%232780C1">
    </a>
    <a href="https://docs.astral.sh/ruff" target="_blank">
       <img alt="Code Style - ruff" src="https://img.shields.io/badge/style-ruff-41B5BE?style=flat">
    </a>
</div>

### Demonstration project that uses `uv` to manage dependencies in a Dockerized setup.

> ### **Why use `uv`?**
> - **Extremely Fast:** `uv` is a Python package and project manager that is _10-100x faster_ than `pip`. 
> - **Universal Lockfile:** Provides comprehensive project management with a universal lockfile.
> - **Comprehensive Tooling:** Runs and installs tools published as Python packages. <br>
> — (Source: [uv docs](https://docs.astral.sh/uv/))

---


## Table of Contents
1. [Initial Setup](#initial-setup)
2. [Usage](#usage)
   - [Production Mode](#production-mode)
   - [Development Mode](#development-mode)
3. [Linting](#linting)
4. [Tests](#tests)
5. [License](#license)
6. [Author](#Author)


## 1. Initial Setup

Docker must be installed and running on your machine. 

Clone the project from GitHub: 

```bash
git clone https://github.com/rebeccabuchholz/uv-docker.git
```


## 2. Usage

The project application has an API powered by [FastAPI](https://fastapi.tiangolo.com).

`uv-docker` can be built and run in the following modes:
- Production 
- Development 
- Production and Development simultaneously  

### Production Mode

Build and run the project in production mode to utilize functionality already existing in project.  

Open a terminal and navigate to the project directory, then execute:
```bash
docker compose up --build uv-prod
```

After the ```uv-prod``` container is running the following endpoints are accessible.

| Endpoint                         | Method    | Purpose             | Expected Output           |
|----------------------------------|-----------|---------------------|---------------------------|
| http://127.0.0.1:8000            | ```GET``` | Swagger Docs        | HTML interactive docs     |
| http://127.0.0.1:8000/glow-check | ```GET``` | Check status of app | ```{"blacklight":"ON"}``` |

### Development Mode

Build and run the project in development mode to view live changes made in the source code.

Development mode can also be used to run the test suite. 

Open a terminal and navigate to the project directory, then execute:
```bash
docker compose up --build uv-dev
```

After the ```uv-dev``` container is running the following endpoints are accessible.

| Endpoint                         | Method    | Purpose             | Expected Output           |
|----------------------------------|-----------|---------------------|---------------------------|
| http://127.0.0.1:8010            | ```GET``` | Swagger docs        | HTML interactive docs     |
| http://127.0.0.1:8010/glow-check | ```GET``` | Check status of app | ```{"blacklight":"ON"}``` |

**Note**: The port for the ```uv-dev``` container application is assigned to ```8010```.

To restart the stopped ```uv-dev``` container without rebuilding the image execute:
```bash
docker start uv-dev
```

#### Live Code Change Example
- After making a change to the local code you can live view the new output in the application
- Change the response value in the local code file ```src/main.py``` for the endpoint ```/glow-check``` to `{"blacklight":"Glowing"}`
- Execute a new curl request or if viewing in the browser refresh the page for http://127.0.0.1:8010/glow-check 
- The response will have the newly changed value: `{"blacklight":"Glowing"}`
- It may take a few seconds for the uvicorn server to restart after code changes


#### Adding or Updating a Dependency 

Add a new dependency or update the version of a dependency in `pyproject.toml`.
- Production dependencies example:
  ```toml
  dependencies = [
      "fastapi[standard]==0.115.13"
  ] 
  ```
- Development dependencies example:
  ```toml
  [dependency-groups]
  dev = [
    "pytest>=8.4.1",
    "pytest-cov>=6.2.1"
  ] 
  ```

**Note:** After adding/updating a dependency it is necessary to update the `uv.lock` file, execute:
```bash
docker compose run --rm uv-dev uv lock 
```


## 3. Linting

The project can be linted using [ruff](https://docs.astral.sh/ruff/) without having to install it in a container.

Check for linting errors:
```bash
docker compose run --rm uv-dev uvx ruff check
```

Fix linting errors by using the ```--fix``` option: 
```bash
docker compose run --rm uv-dev uvx ruff check --fix
```


## 4. Tests

The test suite can only be executed if the ```uv-dev``` container is running.  
```bash
docker exec -it uv-dev uv run pytest --cov=src --cov-report=term -vv
```

## 5. License

[MIT](https://raw.githubusercontent.com/rebeccabuchholz/uv-docker/refs/heads/main/LICENSE)


## 6. Author

<a href="http://www.linkedin.com/in/rebeccabuchholz" target="_blank">Rebecca Buchholz</a>