Name:           python310
Version:        3.10.1
Release:        1
Summary:        Python Interpreter
License:        BSD
AutoReq:        no
Requires:       gcc
URL:            https://www.python.org/
Packager: 	    ssfdust

%description
Python is an accessible, high-level, dynamically typed, interpreted programming language, designed with an emphasis on code readability.

%prep
exit 0

%build
exit 0

%install
install -dm755 $RPM_BUILD_ROOT/opt
install -dm755 $RPM_BUILD_ROOT/usr
install -dm755 $RPM_BUILD_ROOT/usr/bin
install -dm755 $RPM_BUILD_ROOT/etc/ld.so.conf.d/
install -m644 /etc/ld.so.conf.d/python3.conf $RPM_BUILD_ROOT/etc/ld.so.conf.d/
cp -a /opt/pydeps $RPM_BUILD_ROOT/opt
cp -a /opt/python3 $RPM_BUILD_ROOT/opt
ln -sf /opt/python3/bin/python3 $RPM_BUILD_ROOT/usr/bin/python3
ln -sf /opt/python3/bin/pip3 $RPM_BUILD_ROOT/usr/bin/pip3
exit 0

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%files
/usr/bin/python3
/usr/bin/pip3
/etc/ld.so.conf.d/python3.conf
/opt/python3/*
/opt/pydeps/*
