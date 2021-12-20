all: download build run

download:
	@[ ! -d src ] && mkdir src || true
	@[ ! -d src/Python-3.10.1 ] && wget --no-check-certificate https://www.python.org/ftp/python/3.10.1/Python-3.10.1.tgz -qO - | tar xvz -C src || true
	@[ ! -d src/perl-5.34.0 ] && wget --no-check-certificate https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz -qO - | tar xvz -C src || true
	@[ ! -d src/openssl-1.1.1l ] && wget --no-check-certificate https://www.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz -qO - | tar xvz -C src || true
	@[ ! -d src/sqlite-3.37.0 ] && wget --no-check-certificate https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz -qO - | tar --transform "s/autoconf-3370000/3.37.0/" -xvz -C src || true

build:
	podman build -t python-310-centos6-build .

run:
	podman run -v .:/workdir -ti --rm --name python-310-centos6-build python-310-centos6-build bash

deploy:
	rm -rf dist
	podman run -v .:/workdir -ti --rm --name python-310-centos6-build python-310-centos6-build cp /root/rpmbuild/RPMS/x86_64/python310-3.10.1-1.x86_64.rpm /workdir
