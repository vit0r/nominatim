
FROM ubuntu:24.04 as nominatim
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV USERNAME=nominatim
ENV USERHOME=/home/nominatim
ENV PATH=${PATH}:${USERHOME}/.local/bin
RUN useradd -u 1001 -ms /bin/bash ${USERNAME}
WORKDIR ${USERHOME}
RUN apt-get update -qq && apt-get -y install \
    locales apt-utils \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get -y install \
    -o APT::Install-Recommends="false" \
    -o APT::Install-Suggests="false" \
    build-essential \
    net-tools \
    cmake \
    wget \
    libpq-dev \
    zlib1g-dev \
    libbz2-dev \
    libproj-dev \
    libexpat1-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    liblua5.4-dev \
    nlohmann-json3-dev \
    libicu-dev \
    python3-dotenv \
    python3-psycopg2 \
    python3-psutil \
    python3-jinja2 \
    python3-icu \
    python3-datrie \
    python3-yaml \
    python3-pip \
    python3-psycopg \
    python3-sqlalchemy \
    python3-asyncpg \
    postgresql-client
ENV NOMINATIM_VERSION=4.5.0
RUN wget --no-check-certificate \
    https://www.nominatim.org/release/Nominatim-${NOMINATIM_VERSION}.tar.bz2 \
    -O nominatim.tar.bz2 \
    && tar xf nominatim.tar.bz2 \
    && mkdir build \
    && cd build \
    && cmake ../Nominatim-$NOMINATIM_VERSION \
    && make -j`nproc` \
    && make install \
    && apt-get clean
RUN rm -rf nominatim.tar.bz2
RUN rm -rf build
RUN chown $USERNAME:root -R Nominatim-$NOMINATIM_VERSION
ADD nominatim.sh /entrypoint
RUN chmod +x /entrypoint
USER ${USERNAME}
RUN pip install --break-system-packages --no-cache Nominatim-$NOMINATIM_VERSION/packaging/nominatim-api
RUN pip install --break-system-packages --no-cache falcon uvicorn gunicorn osmium
RUN rm -rf Nominatim-$NOMINATIM_VERSION
EXPOSE 8000
ENTRYPOINT [ "/entrypoint" ]

FROM debian:bookworm-slim as nominatim-init
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV USERNAME=nominatim
ENV USERHOME=/home/nominatim
ENV PATH=${PATH}:${USERHOME}/.local/bin
RUN useradd -u 1001 -ms /bin/bash ${USERNAME}
WORKDIR ${USERHOME}
RUN apt update && apt install wget vim -y
ADD init.sh /entrypoint
RUN chmod +x /entrypoint
USER ${USERNAME}
ENTRYPOINT [ "/entrypoint" ]

FROM ubuntu:24.04 as postgres
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV PGUSER=postgres
ENV PGPASSWORD=postgres
ENV PGDATABASE=postgres
ENV PGTZ=America/Sao_Paulo
RUN apt update && apt install -y wget curl gpg net-tools vim
ENV POSTGRES_VERSION=17
ENV PGDATA=/data/postgres/${POSTGRES_VERSION}
ENV PGHOST=/data/postgres/${POSTGRES_VERSION}/run
ENV PATH=${PATH}:/usr/lib/postgresql/$POSTGRES_VERSION/bin
RUN echo "deb http://apt.postgresql.org/pub/repos/apt noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor \
    -o /etc/apt/trusted.gpg.d/postgresql.gpg
RUN apt update && apt install -y postgresql-contrib \
    postgresql-server-dev-${POSTGRES_VERSION} \
    postgresql-${POSTGRES_VERSION}-postgis-3 \
    postgresql-${POSTGRES_VERSION}-postgis-3-scripts
ADD postgresql.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
