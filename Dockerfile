FROM rust:latest as makron
ENV TES3CONV_VERSION=0.4.1
ENV MTM_VERSION=0.9.16
ENV DELTA_PLUGIN_VERSION=0.25.2
ENV HABASI_VERSION=0.3.8
ENV JOBASHA_VERSION=0.6.0
ENV KTOOLS_VERSION=0.1.2
ENV MOTHERJUNGLE_VERSION=0.2.1

RUN apt-get update && apt-get install -y --force-yes unzip 7zip

RUN curl -o tes3cmd -L https://raw.githubusercontent.com/john-moonsugar/tes3cmd/4488c055076b86b4fd220bb39ecc58e025a9b995/tes3cmd && chmod +x tes3cmd && \
    curl -L https://gitlab.com/bmwinger/delta-plugin/-/archive/$DELTA_PLUGIN_VERSION/delta-plugin-$DELTA_PLUGIN_VERSION.tar.gz | tar -xz && \
    curl -L https://github.com/DreamWeave-MP/morrobroom/releases/download/Latest/ubuntu-latest.zip --output morrobroom.zip && unzip morrobroom.zip -d /usr/bin && \
    curl -L https://github.com/magicaldave/motherJungle/releases/download/v$MOTHERJUNGLE_VERSION/bookPatcher-ubuntu-latest.zip --output bookPatcher.zip && unzip bookPatcher.zip -d /usr/bin && \
    curl -L https://github.com/magicaldave/motherJungle/releases/download/v$MOTHERJUNGLE_VERSION/merchantIndexGrabber-ubuntu-latest.zip --output merchantIndexGrabber.zip && unzip merchantIndexGrabber.zip -d /usr/bin && \
    curl -L https://github.com/magicaldave/motherJungle/releases/download/v$MOTHERJUNGLE_VERSION/t3crc-ubuntu-latest.zip --output t3crc.zip && unzip t3crc.zip -d /usr/bin && \
    curl -L https://github.com/magicaldave/motherJungle/releases/download/v$MOTHERJUNGLE_VERSION/addVanillaRefs-ubuntu-latest.zip --output addVanillaRefs.zip && unzip addVanillaRefs.zip -d /usr/bin && \
    curl -L https://github.com/magicaldave/motherJungle/releases/download/v$MOTHERJUNGLE_VERSION/deadDiagFix-ubuntu-latest.zip --output deadDiagFix.zip && unzip deadDiagFix.zip -d /usr/bin && \
    curl -L https://gitlab.com/bmwinger/delta-plugin/-/releases/$DELTA_PLUGIN_VERSION/downloads/delta-plugin-$DELTA_PLUGIN_VERSION-linux-amd64.zip --output deltaPlugin.zip && unzip deltaPlugin.zip -d /usr/bin && \
    curl -L https://github.com/Greatness7/tes3conv/releases/download/v$TES3CONV_VERSION/ubuntu-latest.zip --output tes3conv.zip && unzip tes3conv.zip -d /usr/bin && \
    curl -L https://github.com/Greatness7/merge_to_master/releases/download/v$MTM_VERSION/merge_to_master_v${MTM_VERSION}_ubuntu.zip --output mtm.zip && unzip mtm.zip -d /usr/bin && \
    curl -L https://github.com/DagothGares/kTools/releases/download/$KTOOLS_VERSION/kTools-$KTOOLS_VERSION-linux-gnu-x86_64-ivybridge.tar.gz | tar xz -C /usr/bin/

RUN curl -L https://github.com/alvazir/habasi/archive/refs/tags/$HABASI_VERSION.tar.gz | tar -xz && \
    cargo install --path habasi-$HABASI_VERSION && \
    rm -rf habasi-$HABASI_VERSION

RUN curl -L https://github.com/alvazir/jobasha/archive/refs/tags/$JOBASHA_VERSION.tar.gz | tar -xz && \
    cargo install --path jobasha-$JOBASHA_VERSION && \
    rm -rf jobasha-$JOBASHA_VERSION

COPY *.json build.sh DATA.tar.gz.gpg /

RUN PATH=.:$PATH ./build.sh

FROM ubuntu:24.04
COPY --from=makron [ \
    "/base_StarwindRemasteredPatch.esm", \
    "/nomq_StarwindRemasteredPatch.esm", \
    "/StarwindRemasteredV1.15.esm", \
    "/DATA.tar.gz.gpg", \
    "/plugins/" \
]

COPY --from=makron [ \
    "/usr/local/cargo/bin/habasi", \
    "/usr/local/cargo/bin/jobasha", \
    "/usr/bin/merge_to_master", \
    "/usr/bin/tes3conv", \
    "/usr/bin/delta_plugin", \
    "/usr/bin/morrobroom", \
    "/usr/bin/merchantIndexGrabber", \
    "/usr/bin/deadDiagFix", \
    "/usr/bin/t3crc", \
    "/usr/bin/addVanillaRefs", \
    "/usr/bin/kTools", \
    "/tes3cmd", \
    "/usr/bin/" \
 ]

RUN apt-get update && apt-get install -y --force-yes \
    curl \
    libfile-copy-recursive-perl \
    zip \
    unzip \
    make \
    gpg \
    libluajit-5.1-2

RUN mkdir -p $HOME/.config/openmw && printf 'data="/plugins" \n\
    data="/build" \n\
    ' \ > $HOME/.config/openmw/openmw.cfg

WORKDIR /plugins
