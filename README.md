# URL Shortener

A URL Shortener Generator API, including URL generator, redirect, and visitor statistics.

## Table of Contents

- [URL Shortener](#url-shortener)
  - [Table of Contents](#table-of-contents)
  - [Links](#links)
  - [Tech stack](#tech-stack)
    - [API Framework](#api-framework)
    - [Database](#database)
    - [Caching](#caching)
    - [Task Queue](#task-queue)
    - [Cloud Services](#cloud-services)
    - [Developer Tools](#developer-tools)
    - [Middleware](#middleware)
    - [Utilities](#utilities)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Steps](#steps)
  - [Swagger](#swagger)
  - [Style Guides](#style-guides)
  - [Contribution](#contribution)
  - [Deployment](#deployment)
  - [Infrastructure](#infrastructure)

## Links

- [API Documentation (Swagger)](https://s.ronbraha.codes/swagger/)
- [Github repository](https://github.com/RNR1/url-shortener/)

## Tech stack

### [API Framework](#api-framework)

- [Django](https://www.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)

### [Database](#database)

- [PostgreSQL](https://www.postgresql.org/)
- [psycopg2](https://pypi.org/project/psycopg2/)

### [Caching](#caching)

- [Redis-py](https://github.com/redis/redis-py)

### [Task Queue](#task-queue)

- [Celery](https://docs.celeryq.dev/en/stable/index.html)
- [Amazon SQS](https://aws.amazon.com/sqs/)

### [Cloud Services](#cloud-services)

- [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

### [Developer Tools](#developer-tools)

- [Django Extensions](https://django-extensions.readthedocs.io/en/latest/)

### [Middleware](#middleware)

- [django-cors-headers](https://github.com/adamchainz/django-cors-headers)
- [Whitenoise](https://pypi.org/project/whitenoise/)

### [Utilities](#utilities)

- [Python Decouple](https://pypi.org/project/python-decouple/)

## Installation

### Prerequisites

- VScode (extensions): Python (nice to have: cSpell for spell-checking).
- Have PostgreSQL installed and running (can also run over docker).
- Nice to have: you should have PgAdmin for a better DB management (can run on docker extensions).

### Steps

- Clone this repository

- Create a virtual environment and install dependencies:

```sh
python3 -m venv venv
# $ Mac: source venv/bin/activate
# $ Windows: source venv/Scripts/activate
pip install --upgrade pip
pip install -r requirements.txt
```

- Create a fresh `.env` file from the `.example.env` for storing the local environment variables:

```sh
cp .example.env .env
```

- In `.env`, You should fill the database credentials, and AWS Credentials.

- Run migrations:

```sh
python manage.py migrate
```

- Collect static files:

```sh
python manage.py collectstatic
```

- Start the app:

```sh
python manage.py runserver
```

- The server will listen on port `8000`

## Swagger

This app ships with an OpenAPI compliant Swagger page, you can access it locally by visiting:
[http://localhost:8000/swagger](http://localhost:8000/swagger)

## Style Guides

- Commit Message Format: [Angular commit message format](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-format).

## Contribution

- After staging your changes, you should create a commit message according to the [commit style guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-format) (provided by Angular).
- Push your changes to a new branch, and compare it to the `main` branch.

## Deployment

This application is configured for continuous delivery to AWS EC2 using GitHub Actions and AWS System Manager.

## Infrastructure

![Infrastructure Chart](/assets/images/chart.jpg)
