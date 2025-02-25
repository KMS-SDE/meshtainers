# syntax = docker/dockerfile:1.2
FROM eclipse-temurin:23.0.2_7-jre-alpine-3.21 as vocabbuilder

RUN ["apk", "add", "zip"]

WORKDIR /tmp

COPY vocabs.zip /tmp/
COPY scripts/buildvocabs.sh /tmp/
RUN ["unzip", "vocabs.zip"]
RUN chmod u+x buildvocabs.sh && chown guest buildvocabs.sh
RUN mkdir /vocabs && chown guest /vocabs    

RUN  --mount=type=secret,id=ulms_api_key /tmp/buildvocabs.sh $(cat /run/secrets/ulms_api_key)
USER guest
RUN zip /vocabs/vocabs_prepped *.csv
USER root
RUN find . ! -name vocabs_prepped.zip -type f -exec rm {} \; 
USER guest
