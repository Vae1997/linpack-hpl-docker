FROM alpine
COPY tools/* /tmp/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update \
 && apk add --no-cache perl gcc musl-dev g++ gfortran make linux-headers openssh-client \
 && export "CFLAGS=-O3 -march=armv8-a -mtune=cortex-a53" \
 && tar xf /tmp/openmpi-4.0.3.tar.gz -C /tmp/ \
 && /tmp/openmpi-4.0.3/configure --prefix=/usr/local \
 && make all && make install \
 && tar xf /tmp/hpl-2.3.tar.gz -C /root/ \
 && cd /tmp && unzip OpenBLAS_0.3.9_version.zip \
 && cd xianyi-OpenBLAS-33f76a6/ \
 && make TARGET=ARMV8 BINARY=64 HOSTCC=gcc FC=/usr/local/bin/mpifort CC=/usr/local/bin/mpicc USE_OPENMP=1 USE_THREAD=1 \
 && cd /root/hpl-2.3 && cp /tmp/Make.aarch64 . \
 && cp /tmp/xianyi-OpenBLAS-33f76a6/libopenblas.a /usr/local/lib/ \
 && make all arch="$(arch)" && make install arch="$(arch)" \
 && apk del --purge perl musl-dev g++ make linux-headers gfortran \
 && apk add --no-cache gcc \
 && rm -rf /var/cache/apk/* && rm -rf /var/lib/apk/* && rm -rf /etc/apk/cache/* \
 && rm -rf /tmp/* && cp /root/hpl-2.3/bin/aarch64/* /root/ \
 && rm -rf /root/hpl-2.3/ \
 && cd / && rm -rf contrib/ ompi/ opal/ orte/ oshmem/ test/ Makefile libtool config*
# cd ~ && mpirun -n 4 --allow-run-as-root ./xhpl > r.txt
