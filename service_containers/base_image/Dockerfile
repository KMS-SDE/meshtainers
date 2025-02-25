FROM postgres:17.3-bookworm
RUN apt-get update && apt-get install -y supervisor postgresql procps wget apt-transport-https gpg
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
RUN apt-get update && apt-get install -y temurin-23-jdk/bookworm


RUN adduser trino
WORKDIR /home/trino
RUN mkdir -p /home/trino/data
RUN wget https://repo1.maven.org/maven2/io/trino/trino-server/470/trino-server-470.tar.gz
RUN tar -xzf trino-server-470.tar.gz
COPY config.properties /home/trino/trino-server-470/etc/config.properties
COPY jvm.config /home/trino/trino-server-470/etc/jvm.config
COPY node.properties /home/trino/trino-server-470/etc/node.properties

COPY supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /tmp
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]