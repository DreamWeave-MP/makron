FROM rust:1.67 as makron
ENV TES3CONV_VERSION=0.0.10
ENV DELTA_PLUGIN_VERSION=0.21.0
ENV HABASI_VERSION=0.3.1
ENV JOBASHA_VERSION=0.5.0
RUN rustup install nightly
RUN curl -o tes3cmd -L https://raw.githubusercontent.com/john-moonsugar/tes3cmd/4488c055076b86b4fd220bb39ecc58e025a9b995/tes3cmd && chmod +x tes3cmd; \
    curl -L https://github.com/alvazir/habasi/archive/refs/tags/$HABASI_VERSION.tar.gz | tar -xz; \
    curl -L https://github.com/alvazir/jobasha/archive/refs/tags/$JOBASHA_VERSION.tar.gz | tar -xz; \
    curl -L https://gitlab.com/bmwinger/delta-plugin/-/archive/$DELTA_PLUGIN_VERSION/delta-plugin-$DELTA_PLUGIN_VERSION.tar.gz | tar -xz; \
    curl -L https://github.com/magicaldave/Morrobroom/archive/refs/heads/master.tar.gz | tar -xz; \
    curl -L https://github.com/magicaldave/motherJungle/archive/refs/heads/main.tar.gz | tar -xz; \
    curl -L https://github.com/Greatness7/tes3conv/releases/download/v$TES3CONV_VERSION/tes3conv-ubuntu-latest.tar.gz | tar -xz -C /usr/local/cargo/bin/
RUN cargo +nightly install --path habasi-$HABASI_VERSION && rm -rf habasi-$HABASI_VERSION
RUN cargo +nightly install --path jobasha-$JOBASHA_VERSION && rm -rf jobasha-$JOBASHA_VERSION
RUN cargo +nightly install --path delta-plugin-$DELTA_PLUGIN_VERSION && rm -rf delta-plugin-$DELTA_PLUGIN_VERSION
RUN cargo +nightly install --path Morrobroom-master && rm -rf Morrobroom-master
RUN cargo +nightly install --path motherJungle-main/merchantIndexGrabber
RUN cargo +nightly install --path motherJungle-main/deadDiagFix
RUN cargo +nightly install --path motherJungle-main/makeExteriorCells
RUN cargo +nightly install --path motherJungle-main/t3crc
RUN cargo +nightly install --path motherJungle-main/addVanillaRefs && rm -rf motherJungle-main
COPY *.json build.sh /
RUN PATH=.:$PATH ./build.sh

FROM ubuntu:22.04
COPY --from=makron [ \
    "/base_StarwindRemasteredPatch.esm", \
    "/nomq_StarwindRemasteredPatch.esm", \
    "/StarwindRemasteredV1.15.esm", \
    "/plugins/" \
]

COPY --from=makron [ \
    "/usr/local/cargo/bin/delta_plugin", \
    "/usr/local/cargo/bin/habasi", \
    "/usr/local/cargo/bin/jobasha", \
    "/usr/local/cargo/bin/tes3conv", \
    "/usr/local/cargo/bin/morrobroom", \
    "/usr/local/cargo/bin/merchantIndexGrabber", \
    "/usr/local/cargo/bin/deadDiagFix", \
    "/usr/local/cargo/bin/make_exterior_cells", \
    "/usr/local/cargo/bin/t3crc", \
    "/usr/local/cargo/bin/add_vanilla_refs", \
    "/tes3cmd", \
    "/usr/bin/" \
 ]

COPY tools/merge_to_master /usr/bin/

RUN apt-get update && apt-get install -y --force-yes \
    curl \
    libfile-copy-recursive-perl \
    zip \
    make \
    libluajit-5.1-2
RUN mkdir -p $HOME/.config/openmw && echo "data=\"/plugins\"" > $HOME/.config/openmw/openmw.cfg
WORKDIR /plugins
