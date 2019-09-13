FROM ubuntu

RUN apt-get update
RUN apt-get -y install build-essential pkg-config cmake make wget dumb-init
RUN apt-get -y install libglib2.0-dev libexpat1-dev libjpeg-dev libexif-dev libpng-dev libtiff-dev libavcodec-dev libswscale-dev fftw-dev

RUN apt-get -y install wget
RUN wget https://github.com/libvips/libvips/releases/download/v8.8.2/vips-8.8.2.tar.gz
RUN tar xzf vips-8.8.2.tar.gz
RUN cd vips-8.8.2 && chmod +x ./configure && ./configure
RUN cd vips-8.8.2 && make && make install

ADD . /tifig

RUN \
 mkdir /tifig/build &&\
 cd /tifig/build &&\
 cmake .. &&\
 make

RUN ldconfig
RUN cp /tifig/build/tifig /usr/bin/tifig

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["tifig"]
