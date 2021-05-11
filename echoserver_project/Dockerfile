FROM clux/muslrust:1.51.0-stable as base
ARG TARGET="x86_64-unknown-linux-musl"
ENV TARGET=$TARGET
RUN rustup target add $TARGET



FROM base AS planner
RUN cargo install cargo-chef
WORKDIR /usr/src/project
COPY app/ ./
RUN cargo chef prepare --recipe-path ./recipe.json



FROM base AS cacher
RUN cargo install cargo-chef
WORKDIR /usr/src/project
COPY --from=planner /usr/src/project/recipe.json ./recipe.json
COPY ../.cargo ./.cargo
RUN cargo chef cook --recipe-path ./recipe.json --target $TARGET --release



FROM base AS builder
WORKDIR /usr/src/project
COPY --from=cacher /usr/src/project/target ./target
COPY --from=cacher /usr/src/project/.cargo ./.cargo
COPY --from=cacher /root/.cargo /root/.cargo
COPY app ./
RUN cargo build --bin myapp --target $TARGET --release
#RUN ldd ./target/$TARGET/release/myapp



FROM alpine:3.13
#RUN apk --no-cache add ca-certificates postgresql-dev
RUN apk --no-cache add ca-certificates
ARG TARGET="x86_64-unknown-linux-musl"
WORKDIR /usr/local/bin
COPY --from=builder /usr/src/project/target/$TARGET/release/myapp ./myapp
ENTRYPOINT ["./myapp"]
