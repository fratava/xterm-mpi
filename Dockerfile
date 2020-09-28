FROM tsl0922/musl-cross
RUN git clone --depth=1 https://github.com/tsl0922/ttyd.git /ttyd \
    && cd /ttyd && env BUILD_TARGET=x86_64 WITH_SSL=true ./scripts/cross-build.sh

FROM ubuntu:18.04
COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd

LABEL maintaainer="Francisco Tapia <f.tapia@irya.unam.mx>"

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

RUN apt update \
    && apt install -y build-essential curl wget git gcc gfortran make emacs25 \
    && apt install -y openmpi-bin openssh-client openssh-server libopenmpi-dev

WORKDIR /home

RUN git clone https://github.com/fratava/mpi_code.git

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.4-linux-x86_64.tar.gz \
    && tar zxvf julia-0.6.4-linux-x86_64.tar.gz \
    && ln -s /home/julia-9d11f62bcb/bin/julia /bin/ \
    && rm julia-0.6.4-linux-x86_64.tar.gz

ADD ./test.sh .

RUN chmod u+x test.sh

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]