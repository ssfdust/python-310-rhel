FROM centos:6.9
ENV INSTALLPATH=/usr/local/src/python310-src
COPY . $INSTALLPATH
RUN cd $INSTALLPATH && bash build-env.sh && bash build-rpm.sh
CMD python3
