FROM python:3.9-slim-buster as base

ARG SERVICE_NAME
ENV SERVICE_NAME ${SERVICE_NAME:-api}

# GO ENV VARS
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH="/opt:${PYTHONPATH}"

WORKDIR /opt

RUN apt-get update \
  && apt-get -y install gcc netcat net-tools \
  && apt-get clean

RUN pip install --upgrade pip
COPY ./requirements_$SERVICE_NAME.txt .
RUN pip install -r ./requirements_$SERVICE_NAME.txt

COPY icon_metrics ./icon_metrics

FROM base as test

FROM base as prod
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh
ENTRYPOINT ./entrypoint.sh $SERVICE_NAME
