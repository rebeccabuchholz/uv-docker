# uv-docker

<div>
    <a href="https://github.com/rebeccabuchholz/uv-docker/blob/main/LICENSE" target="_blank">
      <img alt="License" src="https://img.shields.io/pypi/l/websnap?color=%232780C1">
    </a>
    <a href="https://docs.astral.sh/ruff" target="_blank">
       <img alt="Code Style - ruff" src="https://img.shields.io/badge/style-ruff-41B5BE?style=flat">
    </a>
</div>

### Demonstration project that uses uv to manage dependencies in a Dockerized setup.

#### Why should you use uv?

> - uv is an extremely fast Python package and project manager that is 10-100x faster than pip 
> - Provides comprehensive project management with a universal lockfile
> - Installs and manages Python versions <br>
> — [uv](https://docs.astral.sh/uv/)

---


## Table of Contents
1. [Installation](#installation)
    - [Initial Setup](#initial-setup)
    - [Production Mode](#production-mode)
    - [Development Mode](#development-mode)


## Installation

`uv-docker` can be built and run in the following modes:
- Production Mode
- Development Mode
- Both Production and Development Modes simultaneously  

### Initial Setup

Docker must be installed and running. 

Clone the project from GitHub: 

```bash
git clone https://github.com/rebeccabuchholz/uv-docker.git
```

### Production Mode

Build and run the project in production mode to utilize functionality already existing in project.  

Open a terminal and navigate to the project directory, then execute:
```bash
docker compose up --build uv-prod
```

### Development Mode

Build and run the production in development mode to view live changes made in the source code and run the test suite. 

Open a terminal and navigate to the project directory, then execute:
```bash
docker compose up --build uv-dev
```