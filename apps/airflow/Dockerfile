ARG AIRFLOW_BASE_IMG_TAG=2.8.0-python3.11

FROM apache/airflow:${AIRFLOW_BASE_IMG_TAG}

USER root

RUN apt update && \
    ACCEPT_EULA=Y apt -y upgrade \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow
ARG DAG_FACTORY_VERSION=0.19.0
RUN pip install --no-cache-dir dag-factory==${DAG_FACTORY_VERSION}