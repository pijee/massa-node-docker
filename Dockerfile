FROM ubuntu:latest AS compiler
SHELL [ "/bin/bash", "-c" ]
ENV TZ=Europe/Paris
ENV PKG_CONFIG_SYSROOT_DIR=/
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /build

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y pkg-config curl git build-essential libssl-dev musl-dev musl-tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source $HOME/.cargo/env
RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl
RUN git clone https://gitlab.com/massalabs/massa.git
RUN cp /usr/include/x86_64-linux-gnu/openssl/opensslconf.h /usr/include/openssl/opensslconf.h
RUN cd massa/massa-node && cargo build --target x86_64-unknown-linux-musl --release
RUN sed -i 's/end_timestamp = 1626440641000/end_timestamp = 9999999999999/g' massa/massa-node/base_config/config.toml

FROM scratch
WORKDIR /massa
COPY --from=compiler /build/massa/target/x86_64-unknown-linux-musl/release/massa-node /massa/massa-node
COPY --from=compiler /build/massa/massa-node/base_config/ /massa/base_config/
COPY --from=compiler /build/massa/massa-node/config/ /massa/config/
COPY --from=compiler /build/massa/massa-node/storage/ /massa/storage/
USER 1000
ENTRYPOINT [ "./massa-node"]