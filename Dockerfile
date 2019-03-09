FROM amazonlinux:latest

RUN yum groupinstall "Development Tools" -y
RUN yum install python3 python3-devel.x86_64 -y

RUN mkdir -p /sources/psycopg2 /sources/postgresql
COPY ./sources /sources/
WORKDIR /sources
RUN tar xzf postgresql.tar.gz -C postgresql --strip-components 1
RUN tar xzf psycopg2.tar.gz -C psycopg2 --strip-components 1

ARG SSL

RUN if [ "$SSL" = "1" ]; then yum install openssl-devel -y; else :; fi

WORKDIR /sources/postgresql
RUN if [ "$SSL" = "1" ]; then \
        ./configure --prefix /sources/postgresql --without-readline --without-zlib --with-openssl; \
    else \
        ./configure --prefix /sources/postgresql --without-readline --without-zlib; \
    fi
RUN make
RUN make install

WORKDIR /sources/psycopg2
RUN sed -i 's/pg_config = /pg_config = \/sources\/postgresql\/bin\/pg_config/g' setup.cfg
RUN sed -i 's/static_libpq = 0/static_libpq = 1/g' setup.cfg
RUN if [ "$SSL" = "1" ]; then sed -i 's/libraries = /libraries = ssl crypto/g' setup.cfg; else :; fi
RUN python3 setup.py build

RUN if [ "$SSL" = "1" ]; then \
        echo "Successfully compiled with SSL support"; \
    else \
        echo "Successfully compiled without SSL support"; \
    fi