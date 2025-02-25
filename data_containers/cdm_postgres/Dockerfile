# syntax = docker/dockerfile:1.2
FROM postgres:17.3-bookworm AS builder

ENV POSTGRES_USER=omop
ENV POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
ENV POSTGRES_DB=omop54
ENV PGDATA=/data

#ENV vars for the omoploader Python script
#: Path to the Postgres DDL file as downloaded from the OHDSI Github.
ENV YAOL_DDL_FILE=/tmp/omopcdm/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql
#: Postgres connection string.
ENV YAOL_DB_CONN_STR=postgresql://omop@/omop54
#: Name of the Schema to use for the CDM data tables.
ENV YAOL_DB_OMOP_SCHEMA=cdm

RUN apt -y update && apt -y upgrade && apt -y install python3 python3-psycopg python3-dotenv unzip

#Fudge the init script so it will run our scripts but NOT start the postgres daemon at the end.....
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

RUN mkdir ${PGDATA} && chown postgres:postgres ${PGDATA}


WORKDIR /tmp

ADD --chown=postgres:postgres https://github.com/OHDSI/CommonDataModel/releases/download/v5.4.2/OMOPCDM_v5.4.zip /tmp/
ADD --chown=postgres:postgres https://github.com/KMS-SDE/yet-another-omop-loader/archive/refs/tags/v.0.0.1.zip /tmp/

RUN ["unzip", "OMOPCDM_v5.4.zip" ,"-d", "/tmp/omopcdm"]
RUN ["unzip", "v.0.0.1.zip","-d", "/tmp/yaol"]

COPY scripts/buildcdm.sh /docker-entrypoint-initdb.d/
#Run the fudged init script to build the CDM database.
RUN --mount=type=secret,id=postgres_password ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

FROM postgres:17.3-bookworm

ENV POSTGRES_USER=omop
ENV POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
ENV POSTGRES_DB=omop54
ENV PGDATA=/data
#ENV vars for the omoploader Python script
#: Path to the Postgres DDL file as downloaded from the OHDSI Github.
ENV YAOL_DDL_FILE=/tmp/omopcdm/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql
#: Postgres connection string.
ENV YAOL_DB_CONN_STR=postgresql://omop@/omop54
#: Name of the Schema to use for the CDM data tables.
ENV YAOL_DB_OMOP_SCHEMA=cdm
#: Path to the Postgres constraints sql file as downloaded from the OHDSI Github.
ENV YAOL_CONSTRAINTS_FILE=/tmp/omopcdm/5.4/postgresql/OMOPCDM_postgresql_5.4_contraints.sql
#: Path to the Postgres indexes sql file as downloaded from the OHDSI Github.
ENV YAOL_INDICIES_FILE=/tmp/omopcdm/5.4/postgresql/OMOPCDM_postgresql_5.4_indices.sql
#: Path to the Postgres primary keys sql file as downloaded from the OHDSI Github.
ENV YAOL_KEYS_FILE=/tmp/omopcdm/5.4/postgresql/OMOPCDM_postgresql_5.4_keys.sql

RUN apt -y update && apt -y upgrade && apt -y install python3 python3-psycopg python3-dotenv unzip
RUN mkdir ${PGDATA} && chown postgres:postgres ${PGDATA}

USER postgres

COPY --from=builder /data $PGDATA

ADD --chown=postgres:postgres https://github.com/OHDSI/CommonDataModel/releases/download/v5.4.2/OMOPCDM_v5.4.zip /tmp/
ADD --chown=postgres:postgres https://github.com/KMS-SDE/yet-another-omop-loader/archive/refs/tags/v.0.0.1.zip /tmp/

WORKDIR /tmp
RUN ["unzip", "OMOPCDM_v5.4.zip" ,"-d", "/tmp/omopcdm"]
RUN ["unzip", "v.0.0.1.zip","-d", "/tmp/yaol"]
