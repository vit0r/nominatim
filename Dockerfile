
FROM ubuntu:24.04

ARG NOMINATIM_VERSION=4.5.0

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
ADD init.sh /init
ADD entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
RUN chmod +x /init
USER ${USERNAME}
RUN pip install --break-system-packages --no-cache Nominatim-$NOMINATIM_VERSION/packaging/nominatim-api
RUN pip install --break-system-packages --no-cache falcon uvicorn gunicorn
RUN rm -rf Nominatim-$NOMINATIM_VERSION
EXPOSE 8000
ENTRYPOINT [ "/entrypoint" ]