FROM amazonlinux:latest

RUN yum groupinstall "Development Tools" -y -v
RUN yum install python3 python3-devel.x86_64 -y -v

RUN mkdir -p /sources/psycopg2 /sources/postgresql
COPY ./sources /sources/
WORKDIR /sources
RUN tar xzf postgresql.tar.gz -C postgresql --strip-components 1
RUN tar xzf psycopg2.tar.gz -C psycopg2 --strip-components 1

WORKDIR /sources/postgresql
RUN ./configure --prefix /sources/postgresql --without-readline --without-zlib
RUN make
RUN make install

WORKDIR /sources/psycopg2
RUN sed -i 's/pg_config = /pg_config = \/sources\/postgresql\/bin\/pg_config/g' setup.cfg
RUN sed -i 's/static_libpq = 0/static_libpq = 1/g' setup.cfg
RUN python3 setup.py build