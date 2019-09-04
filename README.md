psycopg2 Python 3 Library for AWS Lambda
====

### Why this fork?
**`psycopg2` library needs to be compiled in amazon linux environment.
Most likely you don't have the environment.**

**Solution? Docker!**

This is a custom compiled psycopg2 C library for Python 3. Due to AWS Lambda
missing the required PostgreSQL libraries in the AMI image, we needed to
compile psycopg2 with the PostgreSQL `libpq.so` library statically linked
libpq library instead of the default dynamic link.

### This library is compiled with:

- psycopg2 2.8
- postgresql 11.5
- Python 3.7

### How to use

Copy the `psycopg2` folder in the `build` folder into your AWS Lambda zip package.

### Compile with different versions of libraries

1. Install Docker.
1. Download the
  [PostgreSQL source code](https://ftp.postgresql.org/pub/source) (.tar.gz),
  rename to **postgresql.tar.gz** and put it into `sources` folder.
1. Download the
  [psycopg2 source code](http://initd.org/psycopg/tarballs) (.tar.gz),
  rename to **psycopg2.tar.gz** and put it into `sources` folder.
1. build image: `make build`
1. run image: `make run`
1. delete image if you don't need it anymore: `make clean`

custom compiled psycopg2 library is now in `build` folder.

### Compile with SSL support

- Change step 4 above to: `make build SSL=1`

### Compile on Windows

`makefile` is not available on Windows, there're few options:
- use [cygwin](http://www.cygwin.com) - provide functionality similar to a Linux distribution on Windows.
- use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) - let developers run GNU/Linux environment on Windows 10.
- run docker commands in `makefile` directly.
