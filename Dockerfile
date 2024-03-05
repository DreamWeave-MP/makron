FROM rust:1.67 as makron
ENV TES3CONV_VERSION=0.1.0
ENV DELTA_PLUGIN_VERSION=0.21.0
ENV HABASI_VERSION=0.3.1
ENV JOBASHA_VERSION=0.5.0
RUN rustup install nightly
RUN wget https://github.com/psi29a/tesannwyn/archive/refs/heads/master.zip && unzip master.zip && rm master.zip
RUN wget https://raw.githubusercontent.com/john-moonsugar/tes3cmd/4488c055076b86b4fd220bb39ecc58e025a9b995/tes3cmd
RUN wget https://github.com/alvazir/habasi/archive/refs/tags/$HABASI_VERSION.zip && unzip $HABASI_VERSION.zip && rm $HABASI_VERSION.zip
RUN wget https://github.com/alvazir/jobasha/archive/refs/tags/$JOBASHA_VERSION.zip && unzip $JOBASHA_VERSION.zip && rm $JOBASHA_VERSION.zip
RUN wget https://gitlab.com/bmwinger/delta-plugin/-/archive/$DELTA_PLUGIN_VERSION/delta-plugin-$DELTA_PLUGIN_VERSION.zip && unzip delta-plugin-$DELTA_PLUGIN_VERSION.zip && rm delta-plugin-$DELTA_PLUGIN_VERSION.zip
RUN wget https://github.com/Greatness7/tes3conv/archive/refs/tags/v$TES3CONV_VERSION.zip && unzip v$TES3CONV_VERSION.zip && rm v$TES3CONV_VERSION.zip
RUN wget https://github.com/magicaldave/Morrobroom/archive/refs/heads/master.zip && unzip master.zip && rm master.zip
RUN wget https://github.com/magicaldave/motherJungle/archive/refs/heads/main.zip && unzip main.zip && rm main.zip
RUN cargo +nightly install --path habasi-$HABASI_VERSION && rm -rf habasi-$HABASI_VERSION
RUN cargo +nightly install --path jobasha-$JOBASHA_VERSION && rm -rf jobasha-$JOBASHA_VERSION
RUN cargo +nightly install --path delta-plugin-$DELTA_PLUGIN_VERSION && rm -rf delta-plugin-$DELTA_PLUGIN_VERSION
RUN cargo +nightly install --path tes3conv-$TES3CONV_VERSION && rm -rf tes3conv-$TES3CONV_VERSION
RUN cargo +nightly install --path Morrobroom-master && rm -rf Morrobroom-master
RUN cargo +nightly install --path motherJungle-main/merchantIndexGrabber
RUN cargo +nightly install --path motherJungle-main/deadDiagFix
RUN cargo +nightly install --path motherJungle-main/makeExteriorCells
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
    "/usr/local/cargo/bin/add_vanilla_refs", \
    "/tes3cmd", \
    "/usr/bin/" \
 ]

COPY tools/merge_to_master /usr/bin/
WORKDIR /plugins
