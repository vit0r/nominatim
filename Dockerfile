FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV USERNAME=nominatim
ENV USERHOME=/srv/nominatim
ENV NOMINATIM_DATABASE_DSN=NOMINATIM_DATABASE_DSN=pgsql:host=nominatim-postgresql;port=5432;user=postgres;password=nominatim;dbname=nominatim
ENV NOMINATIM_VERSION=4.5.0
ENV NOMINATIM_IMPORT_STYLE=address
ENV NOMINATIM_PBF=https://download.geofabrik.de/south-america/brazil-latest.osm.pbf

WORKDIR ${USERHOME}

RUN apt-get update -qq && apt-get -y install \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get -y install \
    -o APT::Install-Recommends="false" \
    -o APT::Install-Suggests="false" \
    build-essential \
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
    python3-asyncpg
RUN wget --no-check-certificate \
    https://www.nominatim.org/release/Nominatim-${NOMINATIM_VERSION}.tar.bz2 \
    -O nominatim.tar.bz2 \
    && tar xf nominatim.tar.bz2 \
    && mkdir build \
    && cd build \
    && cmake ../Nominatim-$NOMINATIM_VERSION \
    && make -j`nproc` \
    && make install \
    && rm -rf nominatim.tar.bz2 \
    *.tar.bz2 \
    Nominatim-$NOMINATIM_VERSION \
    /tmp/* \
    build \
    /var/tmp/* \
    && apt-get clean

ADD entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]