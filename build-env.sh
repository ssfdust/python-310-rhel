function Prepare() {
    mv "$INSTALLPATH"/src/* /usr/local/src
    echo "nameserver 114.114.114.114" > /etc/resolv.conf
}

function UpdateRepos() {
    install -m644 "$INSTALLPATH"/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
    yum makecache && yum update -y
}

function InstallBuildDeps() {
    yum install -y gcc zlib-devel bzip2 bzip2-devel patch xz-devel ncurses-devel gdbm-devel readline-devel uuid-devel libffi-devel
}

function BuildPerl() {
    cd /usr/local/src/perl-5.34.0
    ./configure.gnu --prefix=/usr/local/ && make -j$(nproc) && make install
}

function BuildOpenssl() {
    cd /usr/local/src/openssl-1.1.1l
    ./config --prefix=/opt/pydeps/openssl --openssldir=/opt/pydeps/openssl no-ssl2 && make -j$(nproc) && make install_sw
}

function BuildSqlite(){
    cd /usr/local/src/sqlite-3.37.0
    ./configure --prefix=/opt/pydeps && make -j$(nproc) && make install
}

function BuildPython(){
    export LDFLAGS="-L/opt/pydeps/lib -Wl,-rpath,/opt/pydeps/lib -L/opt/pydeps/openssl/lib -Wl,-rpath,/opt/pydeps/openssl/lib"
    export LD_LIBRARY_PATH=/opt/pydeps/openssl/lib:/opt/pydeps/lib
    export PATH=/opt/pydeps/bin:/opt/pydeps/openssl/bin:$PATH
    export CFLAGS="-I/opt/pydeps/include"
    export PKG_CONFIG_PATH=/opt/pydeps/lib/pkgconfig
    cd /usr/local/src/Python-3.10.1
    patch -p1 -i "$INSTALLPATH"/python.patch
    make clean && make distclean
    ./configure \
      --enable-optimizations \
      --prefix=/opt/python3 \
      --enable-shared \
      --with-openssl=/opt/pydeps/openssl/ \
      --with-computed-gotos \
      --enable-loadable-sqlite-extensions
    make -j$(nproc) && make install
}

function DeployPython() {
    echo "/opt/python3/lib" >> /etc/ld.so.conf.d/python3.conf
    ldconfig
    /opt/python3/bin/pip3 install -r "$INSTALLPATH"/requirements.txt
}

function Main() {
    Prepare
    UpdateRepos
    InstallBuildDeps
    BuildPerl
    BuildOpenssl
    BuildSqlite
    BuildPython
    DeployPython
}

Main
