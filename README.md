psycopg2 Python Library for AWS Lambda
======================================

This is a custom compiled psycopg2 C library for Python. Due to AWS Lambda
missing the required PostgreSQL libraries in the AMI image, we needed to
compile psycopg2 with the PostgreSQL `libpq.so` library statically linked
libpq library instead of the default dynamic link.

### This library is compiled with:

- psycopg2 2.7.7
- postgresql 10.7
- Python 3.7

### How to use

Copy the `psycopg2` directory into your AWS Lambda zip package.

### How to compile with different versions of libraries

Here was the process that was used to build this package. You will need to
perform these steps if you want to build a different version of the psycopg2
library.

*Library needs to be compiled in amazon linux environment. Most likely you don't have the environment.* **Solution? Docker!**

1. Install Docker.
1. Download the
  [PostgreSQL source code](https://ftp.postgresql.org/pub/source) (.tar.gz), rename to `postgresql.tar.gz` and put it into `sources` folder.
1. Download the
  [psycopg2 source code](http://initd.org/psycopg/tarballs) (.tar.gz), rename to `psycopg2.tar.gz` and put it into `sources` folder.
1. build image: `make build`
1. run image: `make run`
1. delete image if you don't need it anymore: `make clean`

custom compiled psycopg2 library is now in `build` folder.

### How to compile without Docker

*IMPORTANT: You need to compile in amazon linux environment.*

1. Follow step 2 and 3 from above instruction.
1. Go into the PostgreSQL source directory and execute the following commands:
    - `./configure --prefix {path_to_postgresql_source} --without-readline --without-zlib`
    - `make`
    - `make install`
1. Go into the psycopg2 source directory and edit the `setup.cfg` file with the following:
    - `pg_config={path_to_postgresql_source}/bin/pg_config`
    - `static_libpq=1`
1. Execute `python setup.py build` in the psycopg2 source directory.

After the above steps have been completed you will then have a build directory
and the custom compiled psycopg2 library will be contained within it.

### Compile with SSL support

To compile with SSL support, steps 2 and 3 above become:

1. Same as above.
1. Go into the PostgreSQL source directory and execute the following commands:
    - `./configure --prefix {path_to_postgresql_source} --without-readline --without-zlib --with-openssl`
    - `make`
    - `make install`
1. Go into the psycopg2 source directory and edit the `setup.cfg` file with the following:
    - `pg_config={path_to_postgresql_source/bin/pg_config}`
    - `static_libpq=1`
    - `libraries=ssl crypto`
1. Same as above.
