FROM alpine
COPY tools/* /tmp/
COPY conf/* /tmp/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
 && apk update \
 && apk add --no-cache gcc gfortran g++ make libc6-compat \
 && tar -xzf /tmp/blas-3.8.0.tgz -C /tmp/ \
 && cd /tmp/BLAS-3.8.0/ \
 && make \
 && ar rv libblas.a *.o \
 && tar -xzf /tmp/cblas.tgz -C /tmp/ \
 && cd /tmp/CBLAS/ \
 && cp /tmp/BLAS-3.8.0/blas_LINUX.a ./ \
 && mv /tmp/Makefile.in /tmp/CBLAS/Makefile.in \
 && make \
 && tar -xzf /tmp/mpich-3.2.1.tar.gz -C /tmp/ \
 && cd /tmp/mpich-3.2.1/ \
 && ./configure --prefix=/usr/local \
 && make \
 && make install \
 && export PATH=/usr/local/bin:$PATH \
 && cp /tmp/CBLAS/lib/* /usr/local/lib/ \
 && cp /tmp/BLAS-3.8.0/blas_LINUX.a /usr/local/lib/ \
 && tar -xzf /tmp/hpl-2.3.tar.gz -C /root/ \
 && cd /root/hpl-2.3/ \
 && mv /tmp/Make.Linux_PII_CBLAS ./ \
 && mv /tmp/Make.top ./ \
 && mv /tmp/Makefile ./ \
 && make arch=Linux_PII_CBLAS \
 && rm -rf /var/cache/apk/* \
 && rm -rf /var/lib/apk/* \
 && rm -rf /etc/apk/cache/* \
 && rm -rf /tmp/* \
 && rm -rf /tmp/._BLAS-3.8.0 \
 && apk del --purge g++ make libc6-compat gcc \
 && cd /root/hpl-2.3/bin/Linux_PII_CBLAS/ \
 && cp ./* /root/ \
 && rm -rf /root/hpl-2.3/
WORKDIR /root/

# mpirun -np 4 ./xhpl > HPL-Benchmark.txt
